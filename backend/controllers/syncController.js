const Session = require("../models/session");
const Subject = require("../models/subject");
const Timetable = require("../models/timetable");
const Attendance = require("../models/attendance");
const attendance = require("../models/attendance");

const uploadSession = async (req, res) => {
    try {
        const session = req.body;
        await Session.findByIdAndUpdate(
            session.id,
            {
                _id: session.id,
                userId: req.user._id,
                startDate: session.startDate,
                endDate: session.endDate,
            },
            {
                upsert: true,
                new: true,
            }
        );

        res.status(200).json({
            success: true,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

const uploadSubjects =
    async (req, res) => {
        try {

            const subjects =
                req.body.subjects;

            for (const subject of subjects) {

                await Subject.findByIdAndUpdate(
                    subject.id,
                    {
                        _id: subject.id,

                        userId: req.user._id,

                        name: subject.name,

                        requiredAttendance:
                            subject.requiredAttendance,
                    },
                    {
                        upsert: true,
                        new: true,
                    }
                );

            }

            res.status(200).json({
                success: true,
            });

        } catch (error) {

            res.status(500).json({
                success: false,
                message: error.message,
            });

        }
    };


const uploadTimetable = async (req, res) => {
    try {
        const timetables = req.body.timetables;
        for (const timetable of timetables) {
            await Timetable.findByIdAndUpdate(timetable.id, {
                _id: timetable.id,

                userId:
                    req.user._id,

                subjectId:
                    timetable.subjectId,

                weekday:
                    timetable.weekday,

                classCount:
                    timetable.classCount,
            },
                {
                    upsert: true,
                    new: true,
                },
            );
        }
        res.status(200).json({
            success: true,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
}



const uploadAttendance = async (req, res) => {
    try {
        const attendance = req.body.attendance;
        for (const record of attendance) {
            await Attendance.findByIdAndUpdate(record.id, {
                _id: record.id,

                userId:
                    req.user._id,

                subjectId:
                    record.subjectId,

                date:
                    record.date,

                totalClasses:
                    record.totalClasses,

                attendedClasses:
                    record.attendedClasses,

                status:
                    record.status,
            },
                {
                    upsert: true,
                    new: true,
                }
            );
        }
        res.status(200).json({
            success: true,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
}


const backupAll = async (req, res) => {
    try {
        const { session, subjects, timetables, attendance } = req.body;
        //deleting old data
        await Subject.deleteMany({
            userId: req.user._id,
        });

        await Timetable.deleteMany({
            userId: req.user._id,
        });

        await Attendance.deleteMany({
            userId: req.user._id,
        });

        await Session.deleteMany({
            userId: req.user._id,
        });

        //session
        if (session) {
            await Session.findByIdAndUpdate(session.id, {
                _id: session.id,
                userId: req.user._id,
                startDate: session.startDate,
                endDate: session.endDate,
            },
                {
                    upsert: true,
                    new: true,
                },);
        }
        //subjects
        if (subjects) {
            for (const subject of subjects) {

                await Subject.findByIdAndUpdate(
                    subject.id,
                    {
                        _id: subject.id,
                        userId: req.user._id,
                        name: subject.name,
                        requiredAttendance:
                            subject.requiredAttendance,
                    },
                    {
                        upsert: true,
                        new: true,
                    },
                );
            }
        }

        //timetables
        if (timetables) {

            for (const timetable of timetables) {

                await Timetable.findByIdAndUpdate(
                    timetable.id,
                    {
                        _id: timetable.id,
                        userId: req.user._id,
                        subjectId:
                            timetable.subjectId,
                        weekday:
                            timetable.weekday,
                        classCount:
                            timetable.classCount,
                    },
                    {
                        upsert: true,
                        new: true,
                    },
                );
            }
        }
        //attendance
        if (attendance) {

            for (const record of attendance) {

                await Attendance.findByIdAndUpdate(
                    record.id,
                    {
                        _id: record.id,
                        userId: req.user._id,
                        subjectId:
                            record.subjectId,
                        date:
                            record.date,
                        totalClasses:
                            record.totalClasses,
                        attendedClasses:
                            record.attendedClasses,
                        status:
                            record.status,
                    },
                    {
                        upsert: true,
                        new: true,
                    },
                );
            }
        }
        res.status(200).json({
            success: true,
            message: "Backup completed successfully",
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
}



const restoreAll = async (req, res) => {
    try {
        const session = await Session.findOne({
            userId: req.user._id,
        });

        const subjects =
            await Subject.find({
                userId: req.user._id,
            });

        const timetables =
            await Timetable.find({
                userId: req.user._id,
            });

        const attendance =
            await Attendance.find({
                userId: req.user._id,
            });
        res.status(200).json({
            success: true,
            session,
            subjects,
            timetables,
            attendance,
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
}

module.exports = {
    uploadSession,
    uploadSubjects,
    uploadTimetable,
    uploadAttendance,
    backupAll,
    restoreAll,
}