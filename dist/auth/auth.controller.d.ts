import { AuthService } from './auth.service';
import { User } from '../entities/user.entity';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    register(userData: {
        name: string;
        email: string;
        phoneNumber: string;
        password: string;
        nationalId: string;
        city?: string;
        state?: string;
        country?: string;
    }): Promise<{
        success: boolean;
        message: string;
        user: User;
    }>;
    login(loginData: {
        emailOrPhone: string;
        password: string;
    }): Promise<{
        success: boolean;
        message: string;
        user: User;
    }>;
    getProfile(id: string): Promise<{
        success: boolean;
        user: User;
    }>;
    updateProfile(id: string, updateData: Partial<User>): Promise<{
        success: boolean;
        message: string;
        user: User;
    }>;
    changePassword(id: string, passwordData: {
        newPassword: string;
    }): Promise<{
        success: boolean;
        message: string;
    }>;
}
