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
            subject: "Reset Your StuHub Password",
            text: `Your OTP is ${otp}. It expires in 10 minutes.`,
            html: `
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>

<body style="margin:0;padding:0;background:#f4f6f9;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0">
<tr>
<td align="center">

<table width="600" cellpadding="0" cellspacing="0"
style="background:#ffffff;border-radius:12px;overflow:hidden;margin-top:40px;">

<tr>
<td
style="background:#111827;padding:30px;text-align:center;">

<h1
style="color:#4CAF50;margin:0;font-size:28px;">
StuHub
</h1>

<p
style="color:#d1d5db;margin-top:8px;">
Smart Attendance Management
</p>

</td>
</tr>

<tr>
<td style="padding:40px;">

<h2 style="margin-top:0;color:#222;">
Password Reset Request
</h2>

<p
style="font-size:16px;color:#555;line-height:1.7;">
We received a request to reset your StuHub password.
</p>

<p
style="font-size:16px;color:#555;">
Use the OTP below to continue:
</p>

<div
style="
margin:35px auto;
width:230px;
padding:18px;
background:#f4f4f4;
border:2px dashed #4CAF50;
border-radius:12px;
text-align:center;
font-size:36px;
font-weight:bold;
letter-spacing:8px;
color:#111827;
">

${otp}

</div>

<p
style="
color:#888;
font-size:14px;
line-height:1.6;
">

This OTP is valid for
<strong>10 minutes</strong>.

</p>

<p
style="
margin-top:30px;
color:#888;
font-size:14px;
">

If you didn't request this password reset,
you can safely ignore this email.

</p>

</td>
</tr>

<tr>
<td
style="
background:#f8f8f8;
padding:20px;
text-align:center;
font-size:13px;
color:#888;
">

© ${new Date().getFullYear()} StuHub

<br><br>

Made with ❤️ for students.

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`,
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

module.exports = { registerUser, loginUser, sendResetOtp, verifyResetOtp, resetPassword };