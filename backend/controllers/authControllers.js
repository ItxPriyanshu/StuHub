const User = require("../models/user");
const bcrypt = require("bcryptjs");
const generateToken = require("../utils/generateToken");

//
const sendEmail = require("../utils/sendEmail");
const crypto = require("crypto");
//
//register
const registerUser = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        //validation
        if (!name || !email || !password) {
            return res.status(400).json({
                suceess: false,
                message: "All fields are required",
            });
        }

        //check existing user
        const existingUSer = await User.findOne({
            email,
        });
        if (existingUSer) {
            return res.status(400).json({
                success: false,
                message: "Email already registered",
            });
        }


        //hash password
        const hashedPassword = await bcrypt.hash(password, 8);

        //create user
        const user = await User.create({
            name,
            email,
            password: hashedPassword,
        });


        //token
        const token = generateToken(user._id);
        res.status(201).json({
            suceess: true,
            message: "User registered successfully",

            token,

            user: {
                id: user._id,
                name: user.name,
                email: user.email,
            }
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};



//login
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        //validation
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: "Fill the required credentials",
            });
        }

        //Find User
        const user = await User.findOne({
            email,
        });
        if (!user) {
            return res.status(400).json({
                success: false,
                message: "Invalid email"
            });
        }


        //compare password
        const isMatch = await bcrypt.compare(password, user.password,);
        if (!isMatch) {
            return res.status(400).json({
                success: false,
                message: "Invalid password",
            });
        }


        //generate token
        const token = generateToken(user._id);

        res.status(200).json({
            success: true,
            messgae: "Login successful",
            token,
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
            },
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            messgae: error.message,
        });
    }
};


const sendResetOtp = async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Email is required",
            });
        }
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({
                suceess: false,
                message: "No account found with this email",
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        //Hash OTP
        const hashedOtp = crypto.createHash("sha256").update(otp).digest("hex");

        //save in database
        user.resetOtp = hashedOtp;
        user.resetOtpExpire = Date.now() + 10 * 60 * 1000; //10 min
        await user.save();

        //send email
        await sendEmail({
            to: user.email,
            subject: "StuHub Password Reset OTP",
            text: `Your OTP is ${otp}. It will expire in 10 minutes.`,
        });
        return res.json({
            success: true,
            messgae: "OTP sent successfully",
        });
    } catch (error) {
        console.log(error);
        return res.status(500).json({
            success: false,
            message: "Something went wrong",
        });
    }
}

const verifyResetOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    if (!email || !otp) {
      return res.status(400).json({
        success: false,
        message: "Email and OTP are required",
      });
    }

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    if (
      !user.resetOtp ||
      !user.resetOtpExpire ||
      user.resetOtpExpire < Date.now()
    ) {
      return res.status(400).json({
        success: false,
        message: "OTP has expired",
      });
    }

    const hashedOtp = crypto
      .createHash("sha256")
      .update(otp)
      .digest("hex");

    if (hashedOtp !== user.resetOtp) {
      return res.status(400).json({
        success: false,
        message: "Invalid OTP",
      });
    }
    user.resetOtpVerified = true;
    await user.save();

    return res.status(200).json({
      success: true,
      message: "OTP verified successfully",
    });

  } catch (err) {
    console.error(err);

    return res.status(500).json({
      success: false,
      message: "Something went wrong",
    });
  }
};

const resetPassword = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: "Email and password are required",
            });
        }

        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        if (!user.resetOtpVerified) {
            return res.status(401).json({
                success: false,
                message: "OTP verification required",
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        user.password = hashedPassword;

        // Clear reset data
        user.resetOtp = null;
        user.resetOtpExpire = null;
        user.resetOtpVerified = false;

        await user.save();

        return res.status(200).json({
            success: true,
            message: "Password reset successfully",
        });

    } catch (err) {
        console.error(err);

        return res.status(500).json({
            success: false,
            message: "Something went wrong",
        });
    }
};

module.exports = { registerUser, loginUser,sendResetOtp,verifyResetOtp,resetPassword };