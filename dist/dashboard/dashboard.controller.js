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
exports.DashboardController = void 0;
const common_1 = require("@nestjs/common");
const dashboard_service_1 = require("./dashboard.service");
let DashboardController = class DashboardController {
    constructor(dashboardService) {
        this.dashboardService = dashboardService;
    }
    async getDashboardStats() {
        try {
            const stats = await this.dashboardService.getDashboardStats();
            return {
                success: true,
                data: stats,
                message: 'Dashboard stats retrieved successfully',
            };
        }
        catch (error) {
            return {
                success: false,
                data: null,
                message: 'Failed to retrieve dashboard stats',
                error: error.message,
            };
        }
    }
    async getTodayEvents() {
        try {
            const events = await this.dashboardService.getTodayEvents();
            return {
                success: true,
                data: events,
                message: events.length > 0 ? 'Today events retrieved successfully' : 'No events for today',
            };
        }
        catch (error) {
            return {
                success: false,
                data: [],
                message: 'Failed to retrieve today events',
                error: error.message,
            };
        }
    }
    async getUserProfile(userId) {
        try {
            const userProfile = await this.dashboardService.getUserProfile(parseInt(userId));
            if (userProfile) {
                return {
                    success: true,
                    data: userProfile,
                    message: 'User profile retrieved successfully',
                };
            }
            else {
                return {
                    success: false,
                    data: null,
                    message: 'User not found',
                };
            }
        }
        catch (error) {
            return {
                success: false,
                data: null,
                message: 'Failed to retrieve user profile',
                error: error.message,
            };
        }
    }
    async getRecentNotices(limit = '5') {
        try {
            const notices = await this.dashboardService.getRecentNotices(parseInt(limit));
            return {
                success: true,
                data: notices,
                message: 'Recent notices retrieved successfully',
            };
        }
        catch (error) {
            return {
                success: false,
                data: [],
                message: 'Failed to retrieve recent notices',
                error: error.message,
            };
        }
    }
    async getHomeData() {
        try {
            const [stats, todayEvents, recentNotices] = await Promise.all([
                this.dashboardService.getDashboardStats(),
                this.dashboardService.getTodayEvents(),
                this.dashboardService.getRecentNotices(3),
            ]);
            return {
                success: true,
                data: {
                    stats,
                    todayEvents,
                    recentNotices,
                },
                message: 'Home data retrieved successfully',
            };
        }
        catch (error) {
            return {
                success: false,
                data: null,
                message: 'Failed to retrieve home data',
                error: error.message,
            };
        }
    }
};
exports.DashboardController = DashboardController;
__decorate([
    (0, common_1.Get)('stats'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DashboardController.prototype, "getDashboardStats", null);
__decorate([
    (0, common_1.Get)('today-events'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DashboardController.prototype, "getTodayEvents", null);
__decorate([
    (0, common_1.Get)('user-profile/:userId'),
    __param(0, (0, common_1.Param)('userId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], DashboardController.prototype, "getUserProfile", null);
__decorate([
    (0, common_1.Get)('recent-notices'),
    __param(0, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], DashboardController.prototype, "getRecentNotices", null);
__decorate([
    (0, common_1.Get)('home-data'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DashboardController.prototype, "getHomeData", null);
exports.DashboardController = DashboardController = __decorate([
    (0, common_1.Controller)('dashboard'),
    __metadata("design:paramtypes", [dashboard_service_1.DashboardService])
], DashboardController);
//# sourceMappingURL=dashboard.controller.js.map