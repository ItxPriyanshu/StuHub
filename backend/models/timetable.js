const mongoose = require("mongoose");

const timetableSchema =
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

  weekday: {
    type: Number,
    required: true,
  },

  classCount: {
    type: Number,
    default: 1,
  },

  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model(
  "Timetable",
  timetableSchema
);