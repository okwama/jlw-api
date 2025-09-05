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
exports.NoticeBoard = void 0;
const typeorm_1 = require("typeorm");
let NoticeBoard = class NoticeBoard {
};
exports.NoticeBoard = NoticeBoard;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], NoticeBoard.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ length: 191 }),
    __metadata("design:type", String)
], NoticeBoard.prototype, "title", void 0);
__decorate([
    (0, typeorm_1.Column)({ length: 191 }),
    __metadata("design:type", String)
], NoticeBoard.prototype, "content", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], NoticeBoard.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)(),
    __metadata("design:type", Date)
], NoticeBoard.prototype, "updatedAt", void 0);
exports.NoticeBoard = NoticeBoard = __decorate([
    (0, typeorm_1.Entity)('NoticeBoard')
], NoticeBoard);
//# sourceMappingURL=notice-board.entity.js.map