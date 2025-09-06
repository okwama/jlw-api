import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
export declare class AuthService {
    private userRepository;
    constructor(userRepository: Repository<User>);
    register(userData: {
        name: string;
        email: string;
        phoneNumber: string;
        password: string;
        nationalId: string;
        city?: string;
        state?: string;
        country?: string;
    }): Promise<User>;
    login(emailOrPhone: string, password: string): Promise<User>;
    findByEmailOrPhone(email: string, phone: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    findByPhone(phone: string): Promise<User | null>;
    findById(id: number): Promise<User | null>;
    updateProfile(id: number, updateData: Partial<User>): Promise<User>;
    changePassword(id: number, newPassword: string): Promise<boolean>;
}
