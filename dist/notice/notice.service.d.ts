import { Repository } from 'typeorm';
import { NoticeBoard } from '../entities/notice-board.entity';
export declare class NoticeService {
    private noticeRepository;
    constructor(noticeRepository: Repository<NoticeBoard>);
    findAll(): Promise<NoticeBoard[]>;
    findOne(id: number): Promise<NoticeBoard>;
    create(notice: Partial<NoticeBoard>): Promise<NoticeBoard>;
    update(id: number, notice: Partial<NoticeBoard>): Promise<NoticeBoard>;
    remove(id: number): Promise<void>;
}
