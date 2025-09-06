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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("../entities/user.entity");
const bcrypt = require("bcrypt");
let AuthService = class AuthService {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    async register(userData) {
        try {
            const existingUser = await this.findByEmailOrPhone(userData.email, userData.phoneNumber);
            if (existingUser) {
                throw new Error('User already exists with this email or phone number');
            }
            const hashedPassword = await bcrypt.hash(userData.password, 10);
            const user = this.userRepository.create({
                ...userData,
                password: hashedPassword,
                role: 'USER',
                status: 1,
                createdAt: new Date(),
                country: userData.country || 'Kenya',
            });
            const savedUser = await this.userRepository.save(user);
            const { password, ...userWithoutPassword } = savedUser;
            return userWithoutPassword;
        }
        catch (error) {
            throw new Error(`Registration failed: ${error.message}`);
        }
    }
    async login(emailOrPhone, password) {
        try {
            const user = await this.findByEmailOrPhone(emailOrPhone, emailOrPhone);
            if (!user) {
                throw new Error('User not found');
            }
            const isPasswordValid = await bcrypt.compare(password, user.password);
            if (!isPasswordValid) {
                throw new Error('Invalid password');
            }
            const { password: _, ...userWithoutPassword } = user;
            return userWithoutPassword;
        }
        catch (error) {
            throw new Error(`Login failed: ${error.message}`);
        }
    }
    async findByEmailOrPhone(email, phone) {
        try {
            const user = await this.userRepository.findOne({
                where: [
                    { email: email },
                    { phoneNumber: phone }
                ]
            });
            return user;
        }
        catch (error) {
            return null;
        }
    }
    async findByEmail(email) {
        try {
            return await this.userRepository.findOne({ where: { email } });
        }
        catch (error) {
            return null;
        }
    }
    async findByPhone(phone) {
        try {
            return await this.userRepository.findOne({ where: { phoneNumber: phone } });
        }
        catch (error) {
            return null;
        }
    }
    async findById(id) {
        try {
            const user = await this.userRepository.findOne({ where: { id } });
            if (user) {
                const { password, ...userWithoutPassword } = user;
                return userWithoutPassword;
            }
            return null;
        }
        catch (error) {
            return null;
        }
    }
    async updateProfile(id, updateData) {
        try {
            if (updateData.password) {
                updateData.password = await bcrypt.hash(updateData.password, 10);
            }
            await this.userRepository.update(id, updateData);
            return await this.findById(id);
        }
        catch (error) {
            throw new Error(`Profile update failed: ${error.message}`);
        }
    }
    async changePassword(id, newPassword) {
        try {
            const hashedPassword = await bcrypt.hash(newPassword, 10);
            await this.userRepository.update(id, { password: hashedPassword });
            return true;
        }
        catch (error) {
            return false;
        }
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], AuthService);
//# sourceMappingURL=auth.service.js.map