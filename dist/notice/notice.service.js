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
exports.NoticeService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const notice_board_entity_1 = require("../entities/notice-board.entity");
let NoticeService = class NoticeService {
    constructor(noticeRepository) {
        this.noticeRepository = noticeRepository;
    }
    async findAll() {
        return this.noticeRepository.find();
    }
    async findOne(id) {
        return this.noticeRepository.findOne({ where: { id } });
    }
    async create(notice) {
        const newNotice = this.noticeRepository.create(notice);
        return this.noticeRepository.save(newNotice);
    }
    async update(id, notice) {
        await this.noticeRepository.update(id, notice);
        return this.findOne(id);
    }
    async remove(id) {
        await this.noticeRepository.delete(id);
    }
};
exports.NoticeService = NoticeService;
exports.NoticeService = NoticeService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(notice_board_entity_1.NoticeBoard)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], NoticeService);
//# sourceMappingURL=notice.service.js.map