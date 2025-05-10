const skiilService = require('../services/skill.service');

exports.getAllSkills = async (req, res, next) => {

    try {
        const skills = await skiilService.getAllSkills();
        res.json(skills);
    }catch (err) {
        next(err);
    }
};
