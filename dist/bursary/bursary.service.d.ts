import { Repository } from 'typeorm';
import { BursaryApplication } from '../entities/bursary-application.entity';
export declare class BursaryService {
    private bursaryApplicationRepository;
    constructor(bursaryApplicationRepository: Repository<BursaryApplication>);
    findAll(): Promise<BursaryApplication[]>;
    findOne(id: number): Promise<BursaryApplication>;
    findByUserId(userId: number): Promise<BursaryApplication[]>;
    findByStatus(status: string): Promise<BursaryApplication[]>;
    create(bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication>;
    update(id: number, bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication>;
    remove(id: number): Promise<void>;
}
