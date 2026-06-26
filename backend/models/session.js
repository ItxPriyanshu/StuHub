const mongoose = require("mongoose");
const sessionSchema = new mongoose.Schema({
    _id:{
        type:String,
    },
    userId:{
        type: mongoose.Schema.Types.ObjectId,
        ref:"User",
        required:true,
    },
    startDate:{
        type:Date,
        required: true,
    },
    endDate:{
        type:Date,
        required:true,
    },
    updatedAt:{
        type:Date,
        default:Date.now,
    },
});

module.exports = mongoose.model("Session",sessionSchema);