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
exports.DashboardService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("../entities/user.entity");
const notice_board_entity_1 = require("../entities/notice-board.entity");
let DashboardService = class DashboardService {
    constructor(userRepository, noticeRepository) {
        this.userRepository = userRepository;
        this.noticeRepository = noticeRepository;
    }
    async getDashboardStats() {
        try {
            const [totalUsers, totalNotices, recentNotices, unreadNotifications] = await Promise.all([
                this.userRepository.count({ where: { status: 1 } }),
                this.noticeRepository.count(),
                this.noticeRepository.count({
                    where: {
                        createdAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
                    },
                }),
                this.noticeRepository.count({
                    where: {
                        createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000),
                    },
                }),
            ]);
            return {
                totalUsers,
                totalNotices,
                recentNotices,
                unreadNotifications,
            };
        }
        catch (error) {
            console.error('Error fetching dashboard stats:', error);
            return {
                totalUsers: 0,
                totalNotices: 0,
                recentNotices: 0,
                unreadNotifications: 0,
            };
        }
    }
    async getTodayEvents() {
        try {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            return await this.noticeRepository.find({
                where: {
                    createdAt: {
                        $gte: today,
                        $lt: tomorrow,
                    },
                },
                order: { createdAt: 'DESC' },
                take: 5,
            });
        }
        catch (error) {
            console.error('Error fetching today events:', error);
            return [];
        }
    }
    async getUserProfile(userId) {
        try {
            return await this.userRepository.findOne({
                where: { id: userId },
                select: ['id', 'name', 'email', 'phoneNumber', 'role', 'department', 'position', 'city', 'country', 'photoUrl'],
            });
        }
        catch (error) {
            console.error('Error fetching user profile:', error);
            return null;
        }
    }
    async getRecentNotices(limit = 5) {
        try {
            return await this.noticeRepository.find({
                order: { createdAt: 'DESC' },
                take: limit,
            });
        }
        catch (error) {
            console.error('Error fetching recent notices:', error);
            return [];
        }
    }
};
exports.DashboardService = DashboardService;
exports.DashboardService = DashboardService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(notice_board_entity_1.NoticeBoard)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], DashboardService);
//# sourceMappingURL=dashboard.service.js.map