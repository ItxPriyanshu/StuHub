const mongoose = require("mongoose");
const subjectSchema = new mongoose.Schema({
    _id: {
        type: String,
    },

    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },

    name: {
        type: String,
        required: true,
    },

    requiredAttendance: {
        type: Number,
        default: 75,
    },

    updatedAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model("Subject",subjectSchema);