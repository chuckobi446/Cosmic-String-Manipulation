import { describe, it, expect, beforeEach } from 'vitest';

// Simulated contract state
let listingCount = 0;
const listings = new Map();
const balances = new Map();

// Simulated contract functions
function createListing(title: string, description: string, price: number, efficiency: number, riskFactor: number, dataUrl: string, seller: string) {
  const listingId = ++listingCount;
  listings.set(listingId, {
    seller,
    title,
    description,
    price,
    efficiency,
    riskFactor,
    dataUrl,
    creationTime: Date.now()
  });
  return listingId;
}

function purchaseListing(listingId: number, buyer: string) {
  const listing = listings.get(listingId);
  if (!listing) throw new Error('Invalid listing');
  const buyerBalance = balances.get(buyer) || 0;
  if (buyerBalance < listing.price) throw new Error('Insufficient balance');
  balances.set(buyer, buyerBalance - listing.price);
  const sellerBalance = balances.get(listing.seller) || 0;
  balances.set(listing.seller, sellerBalance + listing.price);
  return true;
}

function removeListing(listingId: number, remover: string) {
  const listing = listings.get(listingId);
  if (!listing) throw new Error('Invalid listing');
  if (listing.seller !== remover) throw new Error('Not authorized');
  listings.delete(listingId);
  return true;
}

describe('Energy Extraction Marketplace Contract', () => {
  beforeEach(() => {
    listingCount = 0;
    listings.clear();
    balances.clear();
  });
  
  it('should create a new listing', () => {
    const id = createListing('Cosmic String Resonance Harvester', 'Efficient energy extraction using string resonance', 1000000, 85, 3, 'https://example.com/resonance-harvester.data', 'seller1');
    expect(id).toBe(1);
    const listing = listings.get(id);
    expect(listing.title).toBe('Cosmic String Resonance Harvester');
    expect(listing.price).toBe(1000000);
    expect(listing.efficiency).toBe(85);
    expect(listing.riskFactor).toBe(3);
  });
  
  it('should allow purchasing a listing', () => {
    const id = createListing('Gravitational Wave Energy Converter', 'Convert gravitational waves from cosmic strings to usable energy', 500000, 70, 5, 'https://example.com/gw-converter.data', 'seller2');
    balances.set('buyer1', 1000000);
    expect(purchaseListing(id, 'buyer1')).toBe(true);
    expect(balances.get('buyer1')).toBe(500000);
    expect(balances.get('seller2')).toBe(500000);
  });
  
  it('should allow removing a listing', () => {
    const id = createListing('Cosmic String Tapping Device', 'Direct energy extraction by tapping into cosmic strings', 750000, 90, 8, 'https://example.com/string-tapper.data', 'seller3');
    expect(removeListing(id, 'seller3')).toBe(true);
    expect(listings.has(id)).toBe(false);
  });
  
  it('should not allow purchasing with insufficient balance', () => {
    const id = createListing('Quantum Vacuum Energy Extractor', 'Harness quantum vacuum fluctuations near cosmic strings', 2000000, 95, 7, 'https://example.com/quantum-extractor.data', 'seller4');
    balances.set('buyer2', 1000000);
    expect(() => purchaseListing(id, 'buyer2')).toThrow('Insufficient balance');
  });
  
  it('should not allow unauthorized listing removal', () => {
    const id = createListing('Cosmic String Network Energy Grid', 'Distributed energy extraction from cosmic string networks', 1500000, 80, 6, 'https://example.com/string-grid.data', 'seller5');
    expect(() => removeListing(id, 'unauthorized_user')).toThrow('Not authorized');
  });
});

