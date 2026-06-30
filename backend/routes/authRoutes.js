const express = require("express");
const router = express.Router();

const { registerUser, loginUser, sendResetOtp, verifyResetOtp, resetPassword } = require("../controllers/authControllers");

router.post("/register",registerUser);

router.post("/login",loginUser);


//
const sendEmail = require("../utils/sendEmail");

router.post("/send-reset-otp",sendResetOtp);
router.post("/verify-reset-otp",verifyResetOtp);
router.post("/reset-password",resetPassword);
//
module.exports = router;