import { Repository } from 'typeorm';
import { AmbulanceRequest } from '../entities/ambulance-request.entity';
export declare class AmbulanceService {
    private readonly ambulanceRequestRepository;
    constructor(ambulanceRequestRepository: Repository<AmbulanceRequest>);
    findAll(): Promise<AmbulanceRequest[]>;
    findOne(id: number): Promise<AmbulanceRequest | null>;
    create(ambulanceRequestData: Partial<AmbulanceRequest>): Promise<AmbulanceRequest>;
    update(id: number, updateData: Partial<AmbulanceRequest>): Promise<AmbulanceRequest | null>;
    remove(id: number): Promise<void>;
    findByUserId(userId: number): Promise<AmbulanceRequest[]>;
    findByStatus(status: string): Promise<AmbulanceRequest[]>;
    assignAmbulance(id: number, ambulanceId: number, assignedBy: number): Promise<AmbulanceRequest | null>;
    updateStatus(id: number, status: string): Promise<AmbulanceRequest | null>;
    getPendingRequests(): Promise<AmbulanceRequest[]>;
    getAssignedRequests(): Promise<AmbulanceRequest[]>;
    getEmergencyRequests(): Promise<AmbulanceRequest[]>;
}
