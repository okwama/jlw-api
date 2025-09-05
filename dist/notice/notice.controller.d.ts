import { NoticeService } from './notice.service';
import { NoticeBoard } from '../entities/notice-board.entity';
export declare class NoticeController {
    private readonly noticeService;
    constructor(noticeService: NoticeService);
    findAll(): Promise<NoticeBoard[]>;
    findOne(id: string): Promise<NoticeBoard>;
    create(notice: Partial<NoticeBoard>): Promise<NoticeBoard>;
    update(id: string, notice: Partial<NoticeBoard>): Promise<NoticeBoard>;
    remove(id: string): Promise<void>;
}
