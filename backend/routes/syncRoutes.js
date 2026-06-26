const express = require("express");

const router = express.Router();

const protect = require("../middleware/authMIddleware");
const {
  uploadSession, uploadSubjects, uploadTimetable, uploadAttendance, backupAll, restoreAll,
} = require("../controllers/syncController");

router.post(
  "/session",
  protect,
  uploadSession,
);

router.post(
  "/subjects",
  protect,
  uploadSubjects,
);

router.post(
  "/timetables",
  protect,
  uploadTimetable,
);

router.post(
  "/attendance",
  protect,
  uploadAttendance,
);

router.post(
  "/backup",
  protect,
  backupAll,
);


router.get(
  "/restore", protect, restoreAll,
);
module.exports = router;