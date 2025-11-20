// 一个KPI（关键绩效指标）数据模拟层，用于前端开发和测试

// 数据类型定义
export interface KPIProblem {
  _id: string;// 唯一标识
  title: string;// KPI名称，如"月度销售额"
  kpiType: 'quantitative' | 'qualitative' | 'completion';// 指标类型
  targetValue: number;// 目标值
  currentValue?: number;// 当前完成值（可选）
  unit: string;// 单位，如"元"、"%"、"个"
  weight: number; // 权重，如30表示30%
  department: string;// 负责部门
  cycle: 'daily' | 'weekly' | 'monthly' | 'quarterly';// 考核周期
  status: 'active' | 'inactive';// 状态
  responsiblePerson: string;// 负责人
  createdAt: string; // 创建时间
}

// 模拟数据
export const mockKPIList: KPIProblem[] = [
  {
    _id: '1',
    title: '月度销售额',
    kpiType: 'quantitative',
    targetValue: 100000,
    currentValue: 95000,
    unit: '元',
    weight: 30,
    department: '销售部',
    cycle: 'monthly',
    status: 'active',
    responsiblePerson: '张三',
    createdAt: '2024-01-15',
  },
  {
    _id: '2',
    title: '客户满意度',
    kpiType: 'qualitative',
    targetValue: 95,
    currentValue: 92,
    unit: '%',
    weight: 25,
    department: '客服部',
    cycle: 'monthly',
    status: 'active',
    responsiblePerson: '李四',
    createdAt: '2024-01-10',
  },
  {
    _id: '3',
    title: '代码完成数',
    kpiType: 'quantitative',
    targetValue: 50,
    currentValue: 48,
    unit: '个',
    weight: 20,
    department: '技术部',
    cycle: 'monthly',
    status: 'active',
    responsiblePerson: '王五',
    createdAt: '2024-01-20',
  },
];
// 模拟API调用
export const fetchKPIList = (filters?: any): Promise<KPIProblem[]> => {
  return new Promise((resolve) => {
    setTimeout(() => {
      let data = [...mockKPIList];
      // 简单的过滤逻辑
      if (filters?.department) {
        data = data.filter((item) => item.department === filters.department);
      }
      if (filters?.status) {
        data = data.filter((item) => item.status === filters.status);
      }
      resolve(data);
    }, 500);
  });
};
