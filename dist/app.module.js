"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const typeorm_1 = require("@nestjs/typeorm");
const notice_controller_1 = require("./notice/notice.controller");
const notice_service_1 = require("./notice/notice.service");
const user_controller_1 = require("./user/user.controller");
const user_service_1 = require("./user/user.service");
const bursary_controller_1 = require("./bursary/bursary.controller");
const bursary_service_1 = require("./bursary/bursary.service");
const ambulance_controller_1 = require("./ambulance/ambulance.controller");
const ambulance_service_1 = require("./ambulance/ambulance.service");
const activity_controller_1 = require("./activity/activity.controller");
const activity_service_1 = require("./activity/activity.service");
const dashboard_controller_1 = require("./dashboard/dashboard.controller");
const dashboard_service_1 = require("./dashboard/dashboard.service");
const auth_controller_1 = require("./auth/auth.controller");
const auth_service_1 = require("./auth/auth.service");
const user_entity_1 = require("./entities/user.entity");
const notice_board_entity_1 = require("./entities/notice-board.entity");
const bursary_application_entity_1 = require("./entities/bursary-application.entity");
const ambulance_request_entity_1 = require("./entities/ambulance-request.entity");
const activity_entity_1 = require("./entities/activity.entity");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({
                isGlobal: true,
                envFilePath: '.env',
            }),
            typeorm_1.TypeOrmModule.forRoot({
                type: 'mysql',
                host: process.env.DB_HOST,
                port: parseInt(process.env.DB_PORT) || 3306,
                username: process.env.DB_USERNAME,
                password: process.env.DB_PASSWORD,
                database: process.env.DB_DATABASE,
                entities: [__dirname + '/**/*.entity{.ts,.js}'],
                synchronize: false,
                logging: process.env.NODE_ENV === 'development',
                connectTimeout: 10000,
                acquireTimeout: 10000,
                retryAttempts: 3,
                retryDelay: 3000,
            }),
            typeorm_1.TypeOrmModule.forFeature([user_entity_1.User, notice_board_entity_1.NoticeBoard, bursary_application_entity_1.BursaryApplication, ambulance_request_entity_1.AmbulanceRequest, activity_entity_1.Activity]),
        ],
        controllers: [
            notice_controller_1.NoticeController,
            user_controller_1.UserController,
            bursary_controller_1.BursaryController,
            ambulance_controller_1.AmbulanceController,
            activity_controller_1.ActivityController,
            dashboard_controller_1.DashboardController,
            auth_controller_1.AuthController,
        ],
        providers: [
            notice_service_1.NoticeService,
            user_service_1.UserService,
            bursary_service_1.BursaryService,
            ambulance_service_1.AmbulanceService,
            activity_service_1.ActivityService,
            dashboard_service_1.DashboardService,
            auth_service_1.AuthService,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map