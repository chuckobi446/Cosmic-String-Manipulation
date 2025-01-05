import { describe, it, expect, beforeEach } from 'vitest';

// Simulated contract state
let assessmentCount = 0;
const ethicalAssessments = new Map();

// Simulated contract functions
function submitEthicalAssessment(proposalId: number, environmentalImpact: number, societalImpact: number, technologicalRisk: number, longTermConsequences: number, overallRating: number, justification: string, assessor: string) {
  const assessmentId = ++assessmentCount;
  ethicalAssessments.set(assessmentId, {
    assessor,
    proposalId,
    environmentalImpact,
    societalImpact,
    technologicalRisk,
    longTermConsequences,
    overallRating,
    justification,
    timestamp: Date.now()
  });
  return assessmentId;
}

describe('Ethical Framework Contract', () => {
  beforeEach(() => {
    assessmentCount = 0;
    ethicalAssessments.clear();
  });
  
  it('should submit a new ethical assessment', () => {
    const id = submitEthicalAssessment(
        1, // proposalId
        -2, // environmentalImpact
        5,  // societalImpact
        -7, // technologicalRisk
        -3, // longTermConsequences
        -1, // overallRating
        'While the societal benefits are significant, the environmental and technological risks outweigh them.',
        'ethicist1'
    );
    expect(id).toBe(1);
    const assessment = ethicalAssessments.get(id);
    expect(assessment.proposalId).toBe(1);
    expect(assessment.environmentalImpact).toBe(-2);
    expect(assessment.overallRating).toBe(-1);
  });
  
  it('should not allow invalid impact ratings', () => {
    expect(() => submitEthicalAssessment(
        2, // proposalId
        11, // environmentalImpact (invalid)
        5,  // societalImpact
        -7, // technologicalRisk
        -3, // longTermConsequences
        0,  // overallRating
        'Invalid assessment',
        'ethicist2'
    )).toThrow('Invalid assessment');
  });
  
  it('should allow multiple assessments for the same proposal', () => {
    const id1 = submitEthicalAssessment(3, 2, 3, -1, 1, 2, 'Mostly positive impacts', 'ethicist3');
    const id2 = submitEthicalAssessment(3, -1, 2, -3, -2, -1, 'Concerns about long-term consequences', 'ethicist4');
    expect(id1).toBe(1);
    expect(id2).toBe(2);
    expect(ethicalAssessments.get(id1).proposalId).toBe(3);
    expect(ethicalAssessments.get(id2).proposalId).toBe(3);
  });
});

