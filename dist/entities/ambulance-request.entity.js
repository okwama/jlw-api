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
Object.defineProperty(exports, "__esModule", { value: true });
exports.AmbulanceRequest = void 0;
const typeorm_1 = require("typeorm");
let AmbulanceRequest = class AmbulanceRequest {
};
exports.AmbulanceRequest = AmbulanceRequest;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "userId", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "ambulanceId", void 0);
__decorate([
    (0, typeorm_1.Column)({ length: 500 }),
    __metadata("design:type", String)
], AmbulanceRequest.prototype, "purpose", void 0);
__decorate([
    (0, typeorm_1.Column)({ length: 500 }),
    __metadata("design:type", String)
], AmbulanceRequest.prototype, "destination", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'datetime', precision: 3 }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "startDate", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'datetime', precision: 3 }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "endDate", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'text', nullable: true }),
    __metadata("design:type", String)
], AmbulanceRequest.prototype, "notes", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'double', nullable: true }),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "latitude", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'double', nullable: true }),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "longitude", void 0);
__decorate([
    (0, typeorm_1.Column)({ length: 500, nullable: true }),
    __metadata("design:type", String)
], AmbulanceRequest.prototype, "address", void 0);
__decorate([
    (0, typeorm_1.Column)({
        type: 'enum',
        enum: ['pending', 'approved', 'rejected', 'assigned', 'completed', 'cancelled'],
        default: 'pending'
    }),
    __metadata("design:type", String)
], AmbulanceRequest.prototype, "status", void 0);
__decorate([
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", Number)
], AmbulanceRequest.prototype, "assignedBy", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'datetime', precision: 3, nullable: true }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "assignedAt", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'datetime', precision: 3, nullable: true }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "completedAt", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ type: 'datetime', precision: 3 }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ type: 'datetime', precision: 3 }),
    __metadata("design:type", Date)
], AmbulanceRequest.prototype, "updatedAt", void 0);
exports.AmbulanceRequest = AmbulanceRequest = __decorate([
    (0, typeorm_1.Entity)('AmbulanceRequest')
], AmbulanceRequest);
//# sourceMappingURL=ambulance-request.entity.js.map