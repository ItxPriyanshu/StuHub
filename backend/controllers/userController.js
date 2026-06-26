const User = require("../models/user");

const getProfile = async(req,res)=>{
    res.status(200).json({
        success:true,
        user:req.user,
    });
};

const updateProfile = async(req,res)=>{
    try {
        const {name,email} = req.body;
        if(!name || !email){
            return res.status(400).json({
                success:false,
                messgae: "Name and Email required"
            });
        }
        const user = await User.findByIdAndUpdate(req.user._id,{name,email},

            {
                new:true
            }
        );
        res.status(200).json({
            success:true,
            user:{
                id:user._id,
                name:user.name,
                email:user.email
            }
        });
    } catch (error) {
        res.status(500).json({
            success:false,
            message:error.message
        });
    }
};


module.exports = {getProfile,updateProfile};