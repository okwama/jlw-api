import { BursaryService } from './bursary.service';
import { BursaryApplication } from '../entities/bursary-application.entity';
export declare class BursaryController {
    private readonly bursaryService;
    constructor(bursaryService: BursaryService);
    findAll(): Promise<BursaryApplication[]>;
    findByUserId(userId: string): Promise<BursaryApplication[]>;
    findByStatus(status: string): Promise<BursaryApplication[]>;
    findOne(id: string): Promise<BursaryApplication>;
    create(bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication>;
    update(id: string, bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication>;
    remove(id: string): Promise<void>;
}
