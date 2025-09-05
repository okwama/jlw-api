import { DashboardService } from './dashboard.service';
export declare class DashboardController {
    private readonly dashboardService;
    constructor(dashboardService: DashboardService);
    getDashboardStats(): Promise<{
        success: boolean;
        data: {
            totalUsers: number;
            totalNotices: number;
            recentNotices: number;
            unreadNotifications: number;
        };
        message: string;
        error?: undefined;
    } | {
        success: boolean;
        data: any;
        message: string;
        error: any;
    }>;
    getTodayEvents(): Promise<{
        success: boolean;
        data: import("../entities/notice-board.entity").NoticeBoard[];
        message: string;
        error?: undefined;
    } | {
        success: boolean;
        data: any[];
        message: string;
        error: any;
    }>;
    getUserProfile(userId: string): Promise<{
        success: boolean;
        data: import("../entities/user.entity").User;
        message: string;
        error?: undefined;
    } | {
        success: boolean;
        data: any;
        message: string;
        error: any;
    }>;
    getRecentNotices(limit?: string): Promise<{
        success: boolean;
        data: import("../entities/notice-board.entity").NoticeBoard[];
        message: string;
        error?: undefined;
    } | {
        success: boolean;
        data: any[];
        message: string;
        error: any;
    }>;
    getHomeData(): Promise<{
        success: boolean;
        data: {
            stats: {
                totalUsers: number;
                totalNotices: number;
                recentNotices: number;
                unreadNotifications: number;
            };
            todayEvents: import("../entities/notice-board.entity").NoticeBoard[];
            recentNotices: import("../entities/notice-board.entity").NoticeBoard[];
        };
        message: string;
        error?: undefined;
    } | {
        success: boolean;
        data: any;
        message: string;
        error: any;
    }>;
}
