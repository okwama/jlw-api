import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { NoticeBoard } from '../entities/notice-board.entity';
export declare class DashboardService {
    private userRepository;
    private noticeRepository;
    constructor(userRepository: Repository<User>, noticeRepository: Repository<NoticeBoard>);
    getDashboardStats(): Promise<{
        totalUsers: number;
        totalNotices: number;
        recentNotices: number;
        unreadNotifications: number;
    }>;
    getTodayEvents(): Promise<NoticeBoard[]>;
    getUserProfile(userId: number): Promise<User | null>;
    getRecentNotices(limit?: number): Promise<NoticeBoard[]>;
}
