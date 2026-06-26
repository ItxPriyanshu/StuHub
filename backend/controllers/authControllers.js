const User = require("../models/user");
const bcrypt = require("bcryptjs");
const generateToken = require("../utils/generateToken");

//register
const registerUser = async(req,res)=>{
    try {
        const {name,email,password} = req.body;

        //validation
        if(!name || !email || !password){
            return res.status(400).json({
                suceess:false,
                message: "All fields are required",
            });
        }

        //check existing user
        const existingUSer = await User.findOne({
            email,
        });
        if(existingUSer){
            return res.status(400).json({
                success:false,
                message:"Email already registered",
            });
        }


        //hash password
        const hashedPassword = await bcrypt.hash(password,8);

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

            user:{
                id: user._id,
                name:user.name,
                email:user.email,
            }
        })
    } catch (error) {
        res.status(500).json({
            success:false,
            message:error.message,
        });
    }
};



//login
const loginUser = async(req,res)=>{
    try {
        const { email, password } = req.body;
        
        //validation
        if(!email || !password){
            return res.status(400).json({
                success: false,
                message: "Fill the required credentials",
            });
        }

        //Find User
        const user = await User.findOne({
            email,
        });
        if(!user){
            return res.status(400).json({
                success: false,
                message: "Invalid email"
            });
        }


        //compare password
        const isMatch = await bcrypt.compare(password,user.password,);
        if(!isMatch){
            return res.status(400).json({
                success:false,
                message: "Invalid password",
            });
        }


        //generate token
        const token = generateToken(user._id);

        res.status(200).json({
            success:true,
            messgae:"Login successful",
            token,
            user:{
                id: user._id,
                name: user.name,
                email:user.email,
            },
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            messgae: error.message,
        });
    }
};

module.exports = {registerUser,loginUser};