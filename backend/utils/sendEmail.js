const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth:{
        user:process.env.EMAIL_USER,
        pass:process.env.EMAIL_PASSWORD,
    },

});

const sendEmail = async({
    to,subject,text
})=> {
    await transporter.sendMail({
        from:`"StuHub" <${process.env.EMAIL_USER}>`,
        to,
        subject,
        text,
    });
};

module.exports = sendEmail;