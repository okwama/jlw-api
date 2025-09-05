import { AmbulanceService } from './ambulance.service';
import { AmbulanceRequest } from '../entities/ambulance-request.entity';
export declare class AmbulanceController {
    private readonly ambulanceService;
    constructor(ambulanceService: AmbulanceService);
    findAll(): Promise<AmbulanceRequest[]>;
    findByUserId(userId: string): Promise<AmbulanceRequest[]>;
    findByStatus(status: string): Promise<AmbulanceRequest[]>;
    getPendingRequests(): Promise<AmbulanceRequest[]>;
    getAssignedRequests(): Promise<AmbulanceRequest[]>;
    getEmergencyRequests(): Promise<AmbulanceRequest[]>;
    findOne(id: string): Promise<AmbulanceRequest>;
    create(ambulanceRequest: Partial<AmbulanceRequest>): Promise<AmbulanceRequest>;
    update(id: string, updateData: Partial<AmbulanceRequest>): Promise<AmbulanceRequest>;
    assignAmbulance(id: string, body: {
        ambulanceId: number;
        assignedBy: number;
    }): Promise<AmbulanceRequest>;
    updateStatus(id: string, body: {
        status: string;
    }): Promise<AmbulanceRequest>;
    remove(id: string): Promise<void>;
}
