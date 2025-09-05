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
exports.AmbulanceController = void 0;
const common_1 = require("@nestjs/common");
const ambulance_service_1 = require("./ambulance.service");
let AmbulanceController = class AmbulanceController {
    constructor(ambulanceService) {
        this.ambulanceService = ambulanceService;
    }
    findAll() {
        return this.ambulanceService.findAll();
    }
    findByUserId(userId) {
        return this.ambulanceService.findByUserId(+userId);
    }
    findByStatus(status) {
        return this.ambulanceService.findByStatus(status);
    }
    getPendingRequests() {
        return this.ambulanceService.getPendingRequests();
    }
    getAssignedRequests() {
        return this.ambulanceService.getAssignedRequests();
    }
    getEmergencyRequests() {
        return this.ambulanceService.getEmergencyRequests();
    }
    findOne(id) {
        return this.ambulanceService.findOne(+id);
    }
    create(ambulanceRequest) {
        return this.ambulanceService.create(ambulanceRequest);
    }
    update(id, updateData) {
        return this.ambulanceService.update(+id, updateData);
    }
    assignAmbulance(id, body) {
        return this.ambulanceService.assignAmbulance(+id, body.ambulanceId, body.assignedBy);
    }
    updateStatus(id, body) {
        return this.ambulanceService.updateStatus(+id, body.status);
    }
    remove(id) {
        return this.ambulanceService.remove(+id);
    }
};
exports.AmbulanceController = AmbulanceController;
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('user/:userId'),
    __param(0, (0, common_1.Param)('userId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "findByUserId", null);
__decorate([
    (0, common_1.Get)('status/:status'),
    __param(0, (0, common_1.Param)('status')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "findByStatus", null);
__decorate([
    (0, common_1.Get)('pending'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "getPendingRequests", null);
__decorate([
    (0, common_1.Get)('assigned'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "getAssignedRequests", null);
__decorate([
    (0, common_1.Get)('emergency'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "getEmergencyRequests", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "findOne", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "create", null);
__decorate([
    (0, common_1.Put)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "update", null);
__decorate([
    (0, common_1.Put)(':id/assign'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "assignAmbulance", null);
__decorate([
    (0, common_1.Put)(':id/status'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "updateStatus", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AmbulanceController.prototype, "remove", null);
exports.AmbulanceController = AmbulanceController = __decorate([
    (0, common_1.Controller)('ambulance'),
    __metadata("design:paramtypes", [ambulance_service_1.AmbulanceService])
], AmbulanceController);
//# sourceMappingURL=ambulance.controller.js.map