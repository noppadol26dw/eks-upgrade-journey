# EKS Upgrade Checklist Guide

This guide shows how to use the production-ready EKS upgrade checklist.

## Checklist Files

- **`EKS_UPGRADE_CHECKLIST.csv`**: Version-specific checklist for EKS 1.33 → 1.34 (quick reference)
- **`EKS_UPGRADE_CHECKLIST_PRODUCTION.csv`**: Production-ready, version-agnostic checklist (use this for production)

## Using the Production Checklist

### Version Placeholders

Replace these placeholders in the checklist:

- `<CURRENT_VERSION>`: Your current EKS version (e.g., "1.33")
- `<TARGET_VERSION>`: Target EKS version (e.g., "1.34")
- `<DATE>`: Current date in YYYY-MM-DD format
- `<cluster_name>`: Your EKS cluster name

### Priority Levels

The checklist includes a Priority column. Values:

- **Critical**: Must complete before proceeding
- **High**: Important for production safety
- **Medium**: Recommended but not blocking
- **Low**: Optional

### Checklist Sections

1. **Change Management**: Approval, scheduling, communication
2. **Pre-Upgrade: Planning**: Research and preparation
3. **Pre-Upgrade: Backup**: Data and configuration backups
4. **Pre-Upgrade: Baseline**: Performance and metrics capture
5. **Pre-Upgrade: Validation**: Health checks and compatibility
6. **Pre-Upgrade: Configuration**: Terraform updates and review
7. **During Upgrade: Execution**: Monitoring during upgrade
8. **After Upgrade: Control Plane**: Verify control plane upgrade
9. **After Upgrade: Nodes**: Verify node upgrades
10. **After Upgrade: Addons**: Verify addon versions
11. **After Upgrade: Workloads**: Verify application health
12. **After Upgrade: Networking**: Verify network functionality
13. **After Upgrade: Storage**: Verify storage functionality
14. **After Upgrade: Security**: Verify security configuration
15. **After Upgrade: Testing**: Run tests and validations
16. **After Upgrade: Monitoring**: Post-upgrade monitoring
17. **After Upgrade: Documentation**: Update documentation
18. **After Upgrade: Sign-off**: Complete change management

## Customization

### For Non-Production Environments

Remove or mark as "N/A" these sections:
- Change Management
- Change approval
- Maintenance window scheduling
- Stakeholder sign-off

### For Production Environments

Add these items if applicable:
- Database compatibility checks
- External service dependencies
- Multi-region considerations
- Disaster recovery testing
- Compliance requirements

### Version-Specific Notes

Create a separate document for version-specific requirements:

**Example for EKS 1.33 → 1.34:**
- Karpenter requires v1.6.0+
- EBS CSI Driver requires v1.50+
- AppArmor deprecated (migrate to seccomp)
- VolumeAttributesClass graduates to GA

## Usage Workflow

1. **2 weeks before upgrade:**
   - Complete "Pre-Upgrade: Planning" section
   - Complete "Change Management" section
   - Start "Pre-Upgrade: Baseline" capture

2. **1 week before upgrade:**
   - Complete "Pre-Upgrade: Backup" section
   - Complete "Pre-Upgrade: Validation" section
   - Complete "Pre-Upgrade: Configuration" section
   - Get change approval

3. **Day of upgrade:**
   - Review all pre-upgrade items
   - Execute "During Upgrade: Execution" section
   - Complete "After Upgrade" sections

4. **Post-upgrade:**
   - Complete "After Upgrade: Monitoring" (24-48 hours)
   - Complete "After Upgrade: Documentation"
   - Complete "After Upgrade: Sign-off"

## Excel Tips

1. **Add checkboxes**: Use Excel's Developer tab → Insert → Checkbox
2. **Conditional formatting**: Highlight rows based on Status column
3. **Filtering**: Use Excel filters to show only incomplete items
4. **Status values**: Use "Complete", "In Progress", "Blocked", "N/A"
5. **Notes column**: Document issues, timestamps, or decisions

## Version Compatibility

The production checklist works for:
- Any EKS version upgrade (1.x → 1.y)
- Minor version upgrades (e.g., 1.33 → 1.34)
- Patch version upgrades (e.g., 1.34.1 → 1.34.2)

For major version upgrades (e.g., 1.x → 2.x), add additional validation steps for API changes.

## Missing from Original Checklist

The production checklist adds:

- Change management and approval process
- Communication and scheduling
- Complete backup verification
- Performance baseline capture
- Application smoke tests
- Network and storage validation
- Security verification
- Post-upgrade monitoring period
- Documentation updates
- Stakeholder sign-off

These additions make the checklist ready for production.
