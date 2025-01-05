import { describe, it, expect, beforeEach } from 'vitest';

// Simulated contract state
let lastTokenId = 0;
const tokenMetadata = new Map();
const tokenOwners = new Map();

// Simulated contract functions
function mintCosmicString(name: string, description: string, segmentLength: number, energyPotential: number, imageUrl: string, creator: string) {
  const tokenId = ++lastTokenId;
  tokenMetadata.set(tokenId, {
    creator,
    name,
    description,
    segmentLength,
    energyPotential,
    discoveryTime: Date.now(),
    imageUrl
  });
  tokenOwners.set(tokenId, creator);
  return tokenId;
}

function transferCosmicString(tokenId: number, sender: string, recipient: string) {
  if (tokenOwners.get(tokenId) !== sender) throw new Error('Not authorized');
  tokenOwners.set(tokenId, recipient);
  return true;
}

describe('Cosmic String NFT Contract', () => {
  beforeEach(() => {
    lastTokenId = 0;
    tokenMetadata.clear();
    tokenOwners.clear();
  });
  
  it('should mint a new cosmic string NFT', () => {
    const id = mintCosmicString('Alpha Centauri String', 'A cosmic string segment near Alpha Centauri', 1000000, 5000000, 'https://example.com/alpha-centauri-string.jpg', 'discoverer1');
    expect(id).toBe(1);
    const metadata = tokenMetadata.get(id);
    expect(metadata.name).toBe('Alpha Centauri String');
    expect(metadata.segmentLength).toBe(1000000);
    expect(metadata.energyPotential).toBe(5000000);
    expect(tokenOwners.get(id)).toBe('discoverer1');
  });
  
  it('should transfer cosmic string NFT ownership', () => {
    const id = mintCosmicString('Andromeda Loop', 'A looped cosmic string in the Andromeda galaxy', 5000000, 20000000, 'https://example.com/andromeda-loop.jpg', 'discoverer2');
    expect(transferCosmicString(id, 'discoverer2', 'collector1')).toBe(true);
    expect(tokenOwners.get(id)).toBe('collector1');
  });
  
  it('should not allow unauthorized transfers', () => {
    const id = mintCosmicString('Milky Way Knot', 'A complex knotted cosmic string in our galaxy', 3000000, 15000000, 'https://example.com/milky-way-knot.jpg', 'discoverer3');
    expect(() => transferCosmicString(id, 'unauthorized_user', 'collector2')).toThrow('Not authorized');
  });
});

