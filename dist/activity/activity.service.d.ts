import { Repository } from 'typeorm';
import { Activity } from '../entities/activity.entity';
export declare class ActivityService {
    private readonly activityRepository;
    constructor(activityRepository: Repository<Activity>);
    findAll(): Promise<Activity[]>;
    findOne(id: number): Promise<Activity | null>;
    create(activityData: Partial<Activity>): Promise<Activity>;
    update(id: number, updateData: Partial<Activity>): Promise<Activity | null>;
    remove(id: number): Promise<void>;
    findByUserId(userId: number): Promise<Activity[]>;
    findByStatus(status: number): Promise<Activity[]>;
    findByActivityType(activityType: string): Promise<Activity[]>;
    findByDateRange(startDate: string, endDate: string): Promise<Activity[]>;
    findByLocation(location: string): Promise<Activity[]>;
    getUpcomingActivities(): Promise<Activity[]>;
    getCompletedActivities(): Promise<Activity[]>;
    getTotalBudgetByUser(userId: number): Promise<number>;
    getActivitiesByMonth(year: number, month: number): Promise<Activity[]>;
}
