const skiilService = require('../services/skill.service');

exports.getAllSkills = async (req, res, next) => {
    try {
        const skills = await skiilService.getAllSkills();
        res.json(skills);
    } catch (err) {
        next(err);
    }
};

exports.getSkillById = async (req, res, next) => {
    
    try {
        const skill = await skiilService.getSkillById(req.params.id);
        if (!skill) {
            return res.status(404).json({ error: 'Skill not found' });
        }
        res.json(skill);
    } catch (err) {
        next(err);
    }
    
};