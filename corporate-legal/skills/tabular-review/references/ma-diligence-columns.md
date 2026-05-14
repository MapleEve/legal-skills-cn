# M&A Diligence — Standard Column Set

买方视角目标公司合同审查的默认字段。以此为起点，再根据交易结构、尽调清单和并购协议的陈述保证增删字段。本文件不是固定清单；真正重要的字段由交易文件和项目优先级决定。

```yaml
schema:
  name: "M&A Diligence — Standard"
  columns:
    - id: counterparty
      label: "相对方"
      type: verbatim
      prompt: "按合同原文摘录目标公司之外的签约方名称。"

    - id: agreement_type
      label: "协议类型"
      type: classify
      options: [msa, purchase_order, license_in, license_out, lease, services, supply, distribution, nda, joint_venture, loan, guaranty, employment, other]
      prompt: "这是一份什么类型的协议？"

    - id: effective_date
      label: "生效日期"
      type: date
      prompt: "该协议何时生效？"

    - id: term
      label: "期限"
      type: duration
      prompt: "初始期限是多长？"

    - id: auto_renewal
      label: "自动续期"
      type: classify
      options: [none, annual, fixed_period, evergreen]
      prompt: "协议是否自动续期？续期周期是什么？"

    - id: termination_for_convenience
      label: "任意解除"
      type: classify
      options: [none, either_party, target_only, counterparty_only]
      prompt: "任一方能否无因解除？哪一方享有该权利？"

    - id: termination_notice
      label: "解除通知期"
      type: duration
      prompt: "解除协议需要提前多久通知？"

    - id: change_of_control
      label: "控制权变更"
      type: classify
      options: [silent, consent_required, consent_not_unreasonably_withheld, automatic_termination, notice_only, counterparty_right_to_terminate]
      prompt: "协议是否约定目标公司控制权变更？触发条件和后果是什么？"

    - id: assignment
      label: "转让"
      type: classify
      options: [silent, consent_required, consent_not_unreasonably_withheld, freely_assignable, assignable_to_affiliates, non_assignable]
      prompt: "目标公司能否转让该协议？有哪些限制？"

    - id: exclusivity
      label: "排他 / 竞业限制"
      type: classify
      options: [none, exclusive_supplier, exclusive_customer, non_compete, non_solicit, territory_restriction, most_favored_nation]
      prompt: "协议是否限制任一方与他人交易、竞争、招揽或在特定区域经营？"

    - id: liability_cap
      label: "责任上限"
      type: currency
      prompt: "是否存在责任上限？金额、倍数或计算方式是什么？"

    - id: indemnification
      label: "赔偿 / 补偿"
      type: classify
      options: [none, mutual, target_indemnifies, counterparty_indemnifies, ip_only, third_party_claims_only]
      prompt: "谁向谁承担赔偿或补偿义务？覆盖哪些事项？"

    - id: governing_law
      label: "适用法律"
      type: verbatim
      prompt: "协议约定适用哪一法域的法律？"

    - id: dispute_resolution
      label: "争议解决"
      type: classify
      options: [litigation, arbitration_binding, arbitration_nonbinding, mediation_first, silent]
      prompt: "争议如何解决？诉讼、仲裁、调解前置还是未约定？"

    - id: most_favored_nation
      label: "最惠待遇 / 价格保护"
      type: classify
      options: [none, mfn_pricing, price_matching, benchmarking_right]
      prompt: "是否存在最惠待遇、价格匹配或基准比较权？"

    - id: minimum_commitments
      label: "最低采购 / 数量承诺"
      type: currency
      prompt: "是否有最低采购量、最低数量或最低消费承诺？"

    - id: ip_ownership
      label: "知识产权归属"
      type: classify
      options: [each_owns_own, target_owns_work_product, counterparty_owns_work_product, joint, license_only, silent]
      prompt: "协议项下产生或使用的知识产权归谁所有？"

    - id: confidentiality_term
      label: "保密义务存续期"
      type: duration
      prompt: "保密义务在协议终止后持续多久？"

    - id: insurance_requirements
      label: "保险要求"
      type: classify
      options: [none, general_liability, professional_liability, cyber, workers_comp, umbrella]
      prompt: "协议要求维持哪些保险？"

    - id: audit_rights
      label: "审计权"
      type: classify
      options: [none, counterparty_may_audit_target, target_may_audit_counterparty, mutual]
      prompt: "任一方是否享有审计权？审计范围和频率是什么？"

    - id: notices
      label: "通知要求"
      type: verbatim
      prompt: "目标公司的通知地址、通知方式和送达规则是什么？"
```

## 常见行业补充字段

- **医疗器械 / 药品 / 生命科学：** 医疗器械注册证、药品注册批件、NMPA 沟通和审批、临床试验、GMP/GSP、药物警戒、推广合规和经销授权。
- **互联网、数据和算法密集业务：** ICP/EDI 等互联网信息服务许可备案、App 合规、算法备案、生成式 AI 服务备案/安全评估、数据分类分级、重要数据、个人信息处理、数据出境、SDK 和第三方共享。
- **金融业务：** 金融监管总局、证监会、人民银行及交易所/协会规则下的牌照、备案、股东资格、业务范围、资本和风控要求。
- **国资交易：** 国资审批、评估备案、进场交易、产权转让程序、主管部门批复和国有资产流失风险。
- **反垄断：** 经营者集中申报、未依法申报风险、竞争限制条款、排他安排和最惠待遇条款。
- **政府采购 / 涉密 / 军工：** 政府采购合同、供应商资格、涉密资质、军工资质、保密协议、国产化要求和审计检查。
- **环保 / 安监：** 环评、排污许可、危废、消防、安全生产许可、事故记录、整改通知和行政处罚。
- **劳动用工与社保公积金：** 劳动合同、劳务派遣、外包、竞业限制、历史欠薪、社保公积金缴纳、工伤、劳动争议和人员安置。

## 快速初筛常用删减

时间紧张的第一轮初筛中，以下 6 列通常回答大部分早期交易问题：counterparty、effective_date、term、change_of_control、assignment、termination_for_convenience。先跑这些字段，再根据交易团队优先级扩展 schema。
