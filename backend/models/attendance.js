const mongoose = require("mongoose");

const attendanceSchema =
    new mongoose.Schema({

  _id: {
    type: String,
  },

  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },

  subjectId: {
    type: String,
    required: true,
  },

  date: {
    type: String,
    required: true,
  },

  totalClasses: {
    type: Number,
    required: true,
  },

  attendedClasses: {
    type: Number,
    required: true,
  },

  status: {
    type: String,
    required: true,
  },

  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model(
  "Attendance",
  attendanceSchema
);