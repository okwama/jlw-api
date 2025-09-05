"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ActivityService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const activity_entity_1 = require("../entities/activity.entity");
let ActivityService = class ActivityService {
    constructor(activityRepository) {
        this.activityRepository = activityRepository;
    }
    async findAll() {
        try {
            return await this.activityRepository.find({
                order: { startDate: 'ASC' },
            });
        }
        catch (error) {
            console.error('Error fetching activities:', error);
            throw new Error('Failed to fetch activities');
        }
    }
    async findOne(id) {
        try {
            return await this.activityRepository.findOne({ where: { id } });
        }
        catch (error) {
            console.error('Error fetching activity:', error);
            throw new Error('Failed to fetch activity');
        }
    }
    async create(activityData) {
        try {
            const activity = this.activityRepository.create(activityData);
            return await this.activityRepository.save(activity);
        }
        catch (error) {
            console.error('Error creating activity:', error);
            throw new Error('Failed to create activity');
        }
    }
    async update(id, updateData) {
        try {
            await this.activityRepository.update(id, updateData);
            return await this.findOne(id);
        }
        catch (error) {
            console.error('Error updating activity:', error);
            throw new Error('Failed to update activity');
        }
    }
    async remove(id) {
        try {
            await this.activityRepository.delete(id);
        }
        catch (error) {
            console.error('Error deleting activity:', error);
            throw new Error('Failed to delete activity');
        }
    }
    async findByUserId(userId) {
        try {
            return await this.activityRepository.find({
                where: { userId },
                order: { startDate: 'ASC' },
            });
        }
        catch (error) {
            console.error('Error fetching user activities:', error);
            throw new Error('Failed to fetch user activities');
        }
    }
    async findByStatus(status) {
        try {
            return await this.activityRepository.find({
                where: { status },
                order: { startDate: 'ASC' },
            });
        }
        catch (error) {
            console.error('Error fetching activities by status:', error);
            throw new Error('Failed to fetch activities by status');
        }
    }
    async findByActivityType(activityType) {
        try {
            return await this.activityRepository.find({
                where: { activityType },
                order: { startDate: 'ASC' },
            });
        }
        catch (error) {
            console.error('Error fetching activities by type:', error);
            throw new Error('Failed to fetch activities by type');
        }
    }
    async findByDateRange(startDate, endDate) {
        try {
            return await this.activityRepository
                .createQueryBuilder('activity')
                .where('activity.startDate BETWEEN :startDate AND :endDate', { startDate, endDate })
                .orderBy('activity.startDate', 'ASC')
                .getMany();
        }
        catch (error) {
            console.error('Error fetching activities by date range:', error);
            throw new Error('Failed to fetch activities by date range');
        }
    }
    async findByLocation(location) {
        try {
            return await this.activityRepository
                .createQueryBuilder('activity')
                .where('activity.location LIKE :location', { location: `%${location}%` })
                .orderBy('activity.startDate', 'ASC')
                .getMany();
        }
        catch (error) {
            console.error('Error fetching activities by location:', error);
            throw new Error('Failed to fetch activities by location');
        }
    }
    async getUpcomingActivities() {
        try {
            const today = new Date().toISOString().split('T')[0];
            return await this.activityRepository
                .createQueryBuilder('activity')
                .where('activity.startDate >= :today', { today })
                .orderBy('activity.startDate', 'ASC')
                .getMany();
        }
        catch (error) {
            console.error('Error fetching upcoming activities:', error);
            throw new Error('Failed to fetch upcoming activities');
        }
    }
    async getCompletedActivities() {
        try {
            const today = new Date().toISOString().split('T')[0];
            return await this.activityRepository
                .createQueryBuilder('activity')
                .where('activity.endDate < :today', { today })
                .orderBy('activity.endDate', 'DESC')
                .getMany();
        }
        catch (error) {
            console.error('Error fetching completed activities:', error);
            throw new Error('Failed to fetch completed activities');
        }
    }
    async getTotalBudgetByUser(userId) {
        try {
            const result = await this.activityRepository
                .createQueryBuilder('activity')
                .select('SUM(activity.budgetTotal)', 'total')
                .where('activity.userId = :userId', { userId })
                .getRawOne();
            return parseFloat(result.total) || 0;
        }
        catch (error) {
            console.error('Error calculating total budget:', error);
            throw new Error('Failed to calculate total budget');
        }
    }
    async getActivitiesByMonth(year, month) {
        try {
            const startDate = `${year}-${month.toString().padStart(2, '0')}-01`;
            const endDate = `${year}-${month.toString().padStart(2, '0')}-31`;
            return await this.findByDateRange(startDate, endDate);
        }
        catch (error) {
            console.error('Error fetching activities by month:', error);
            throw new Error('Failed to fetch activities by month');
        }
    }
};
exports.ActivityService = ActivityService;
exports.ActivityService = ActivityService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(activity_entity_1.Activity)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], ActivityService);
//# sourceMappingURL=activity.service.js.map