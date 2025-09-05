import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('User')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 255 })
  name: string;

  @Column({ length: 255, unique: true })
  email: string;

  @Column({ length: 20, unique: true })
  phoneNumber: string;

  @Column({ length: 255 })
  password: string;

  @Column({
    type: 'enum',
    enum: ['USER', 'ADMIN', 'FIELD_USER', 'MANAGER', 'SUPERVISOR'],
    default: 'USER'
  })
  role: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ length: 500, nullable: true })
  photoUrl: string;

  @Column({ type: 'tinyint', default: 1 })
  status: number;

  @Column({ length: 100, nullable: true })
  firstName: string;

  @Column({ length: 100, nullable: true })
  lastName: string;

  @Column({ type: 'date', nullable: true })
  dateOfBirth: Date;

  @Column({
    type: 'enum',
    enum: ['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'],
    nullable: true
  })
  gender: string;

  @Column({ length: 20, unique: true, nullable: true })
  nationalId: string;

  @Column({ length: 100, nullable: true })
  address: string;

  @Column({ length: 100, nullable: true })
  city: string;

  @Column({ length: 100, nullable: true })
  state: string;

  @Column({ length: 100, default: 'Kenya' })
  country: string;

  @Column({ length: 20, nullable: true })
  postalCode: string;

  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  latitude: number;

  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  longitude: number;

  @Column({ length: 255, nullable: true })
  emergencyContactName: string;

  @Column({ length: 20, nullable: true })
  emergencyContactPhone: string;

  @Column({ length: 100, nullable: true })
  emergencyContactRelationship: string;

  @Column({ length: 100, nullable: true })
  department: string;

  @Column({ length: 100, nullable: true })
  position: string;

  @Column({ length: 50, unique: true, nullable: true })
  employeeId: string;

  @Column({ type: 'date', nullable: true })
  hireDate: Date;

  @Column({ nullable: true })
  supervisorId: number;

  @Column({
    type: 'enum',
    enum: ['ENGLISH', 'SWAHILI', 'KIKUYU', 'LUHYA', 'KALENJIN', 'OTHER'],
    default: 'ENGLISH'
  })
  preferredLanguage: string;

  @Column({ type: 'json', nullable: true })
  notificationPreferences: any;

  @Column({ type: 'tinyint', default: 0 })
  emailVerified: number;

  @Column({ type: 'tinyint', default: 0 })
  phoneVerified: number;

  @Column({ nullable: true })
  lastLoginAt: Date;

  @Column({ length: 45, nullable: true })
  lastLoginIp: string;

  @Column({ default: 0 })
  failedLoginAttempts: number;

  @Column({ type: 'tinyint', default: 0 })
  accountLocked: number;

  @Column({ nullable: true })
  lockExpiresAt: Date;

  @Column({ nullable: true })
  passwordChangedAt: Date;

  @Column({ nullable: true })
  passwordExpiresAt: Date;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @Column({ type: 'json', nullable: true })
  tags: any;

  @Column({ type: 'json', nullable: true })
  metadata: any;
}
