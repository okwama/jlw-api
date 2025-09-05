import { ActivityService } from './activity.service';
import { Activity } from '../entities/activity.entity';
export declare class ActivityController {
    private readonly activityService;
    constructor(activityService: ActivityService);
    findAll(): Promise<Activity[]>;
    findByUserId(userId: string): Promise<Activity[]>;
    findByStatus(status: string): Promise<Activity[]>;
    findByActivityType(activityType: string): Promise<Activity[]>;
    findByLocation(location: string): Promise<Activity[]>;
    findByDateRange(startDate: string, endDate: string): Promise<Activity[]>;
    getUpcomingActivities(): Promise<Activity[]>;
    getCompletedActivities(): Promise<Activity[]>;
    getActivitiesByMonth(year: string, month: string): Promise<Activity[]>;
    getTotalBudgetByUser(userId: string): Promise<number>;
    findOne(id: string): Promise<Activity>;
    create(activity: Partial<Activity>): Promise<Activity>;
    update(id: string, updateData: Partial<Activity>): Promise<Activity>;
    remove(id: string): Promise<void>;
}
