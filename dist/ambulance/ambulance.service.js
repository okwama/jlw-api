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
exports.AmbulanceService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const ambulance_request_entity_1 = require("../entities/ambulance-request.entity");
let AmbulanceService = class AmbulanceService {
    constructor(ambulanceRequestRepository) {
        this.ambulanceRequestRepository = ambulanceRequestRepository;
    }
    async findAll() {
        try {
            return await this.ambulanceRequestRepository.find({
                order: { createdAt: 'DESC' },
            });
        }
        catch (error) {
            console.error('Error fetching ambulance requests:', error);
            throw new Error('Failed to fetch ambulance requests');
        }
    }
    async findOne(id) {
        try {
            return await this.ambulanceRequestRepository.findOne({ where: { id } });
        }
        catch (error) {
            console.error('Error fetching ambulance request:', error);
            throw new Error('Failed to fetch ambulance request');
        }
    }
    async create(ambulanceRequestData) {
        try {
            const ambulanceRequest = this.ambulanceRequestRepository.create(ambulanceRequestData);
            return await this.ambulanceRequestRepository.save(ambulanceRequest);
        }
        catch (error) {
            console.error('Error creating ambulance request:', error);
            throw new Error('Failed to create ambulance request');
        }
    }
    async update(id, updateData) {
        try {
            await this.ambulanceRequestRepository.update(id, updateData);
            return await this.findOne(id);
        }
        catch (error) {
            console.error('Error updating ambulance request:', error);
            throw new Error('Failed to update ambulance request');
        }
    }
    async remove(id) {
        try {
            await this.ambulanceRequestRepository.delete(id);
        }
        catch (error) {
            console.error('Error deleting ambulance request:', error);
            throw new Error('Failed to delete ambulance request');
        }
    }
    async findByUserId(userId) {
        try {
            return await this.ambulanceRequestRepository.find({
                where: { userId },
                order: { createdAt: 'DESC' },
            });
        }
        catch (error) {
            console.error('Error fetching user ambulance requests:', error);
            throw new Error('Failed to fetch user ambulance requests');
        }
    }
    async findByStatus(status) {
        try {
            return await this.ambulanceRequestRepository.find({
                where: { status },
                order: { createdAt: 'DESC' },
            });
        }
        catch (error) {
            console.error('Error fetching ambulance requests by status:', error);
            throw new Error('Failed to fetch ambulance requests by status');
        }
    }
    async assignAmbulance(id, ambulanceId, assignedBy) {
        try {
            const updateData = {
                ambulanceId,
                assignedBy,
                assignedAt: new Date(),
                status: 'assigned',
            };
            return await this.update(id, updateData);
        }
        catch (error) {
            console.error('Error assigning ambulance:', error);
            throw new Error('Failed to assign ambulance');
        }
    }
    async updateStatus(id, status) {
        try {
            const updateData = { status };
            if (status === 'completed') {
                updateData['completedAt'] = new Date();
            }
            return await this.update(id, updateData);
        }
        catch (error) {
            console.error('Error updating ambulance request status:', error);
            throw new Error('Failed to update ambulance request status');
        }
    }
    async getPendingRequests() {
        return this.findByStatus('pending');
    }
    async getAssignedRequests() {
        return this.findByStatus('assigned');
    }
    async getEmergencyRequests() {
        try {
            return await this.ambulanceRequestRepository
                .createQueryBuilder('request')
                .where('request.status IN (:...statuses)', { statuses: ['pending', 'assigned'] })
                .orderBy('request.createdAt', 'DESC')
                .getMany();
        }
        catch (error) {
            console.error('Error fetching emergency requests:', error);
            throw new Error('Failed to fetch emergency requests');
        }
    }
};
exports.AmbulanceService = AmbulanceService;
exports.AmbulanceService = AmbulanceService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(ambulance_request_entity_1.AmbulanceRequest)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], AmbulanceService);
//# sourceMappingURL=ambulance.service.js.map