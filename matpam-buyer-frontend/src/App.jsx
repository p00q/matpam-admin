import React, { useState, useEffect } from 'react';
import './index.css';

/**
 * Matpam Buyer Frontend - Home/Main Entry
 * Modern Premium UI (Aesthetics-first)
 */
function App() {
  const [products, setProducts] = useState([]);
  const [memberMoney, setMemberMoney] = useState(0);
  const [loading, setLoading] = useState(true);

  // Fetch data from our new Backend REST APIs
  useEffect(() => {
    // API Call: GET http://localhost:8080/api/buyer/products
    // Note: Use absolute URL for dev if proxy is not yet set
    const fetchProducts = async () => {
      try {
        const res = await fetch('http://localhost:8080/api/buyer/products');
        const json = await res.json();
        if (json.status === 'success') {
          setProducts(json.data);
        }
      } catch (err) {
        console.error("Failed to fetch products:", err);
      } finally {
        setLoading(false);
      }
    };

    const fetchMoney = async () => {
      try {
        const res = await fetch('http://localhost:8080/api/buyer/member/money');
        const json = await res.json();
        if (json.status === 'success') {
          setMemberMoney(json.balance);
        }
      } catch (err) {
        console.error("Failed to fetch member money:", err);
      }
    };

    fetchProducts();
    fetchMoney();
  }, []);

  return (
    <div className="buyer-app">
      {/* Premium Header */}
      <header className="glass-card container mt-4" style={{ padding: '1rem 2rem', borderBottom: 'none' }}>
        <div className="d-flex justify-content-between align-items-center">
          <h2 className="gradient-text m-0" style={{ fontSize: '1.8rem', letterSpacing: '-1px' }}>
            MATPAM <span style={{ fontWeight: 300, color: 'var(--text-muted)' }}>BUYER</span>
          </h2>
          <nav className="d-flex gap-4">
            <span className="text-muted">Explore</span>
            <span className="text-muted">Cart</span>
            <div className="premium-money-chip glass-card" 
                 style={{ padding: '0.4rem 1rem', background: 'var(--primary-glow)', borderColor: 'var(--primary)' }}>
              <span style={{ fontSize: '0.8rem', color: 'var(--primary)', fontWeight: 700 }}>MEAT MONEY</span>
              <div style={{ fontSize: '1.1rem', fontWeight: 700 }}>
                {new Intl.NumberFormat().format(memberMoney)} <span style={{ fontSize: '0.7rem' }}>원</span>
              </div>
            </div>
          </nav>
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mt-5 text-center animate-fade-up">
        <h1 style={{ fontSize: '3.5rem', lineHeight: '1.1' }} className="mb-4">
          신선함의 기준을 <span className="gradient-text">재정의</span>합니다.
        </h1>
        <p className="text-muted mx-auto" style={{ maxWidth: '600px', fontSize: '1.2rem' }}>
          맛팜에서만 만날 수 있는 원물 + 가공 프리미엄 육류 구성을 지금 확인해보세요.<br />
          정밀하게 계산된 투명한 가격과 특별한 혜택을 제공합니다.
        </p>
      </section>

      {/* Product Discovery Grid */}
      <main className="container mt-5 pb-5">
        <div className="d-flex justify-content-between align-items-center mb-4">
          <h3 className="font-premium">추천 상품</h3>
          <nav className="d-flex gap-2">
             <button className="glass-card px-3 py-1 text-muted" style={{fontSize: '0.8rem'}}>전체</button>
             <button className="glass-card px-3 py-1 text-muted" style={{fontSize: '0.8rem'}}>전국택배</button>
             <button className="glass-card px-3 py-1 text-muted" style={{fontSize: '0.8rem'}}>직배송</button>
          </nav>
        </div>

        {loading ? (
          <div className="text-center py-5">
            <div className="gradient-text fw-bold">Loading Premium Experience...</div>
          </div>
        ) : (
          <div className="product-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '2.5rem' }}>
            {products.map((prod) => (
              <div key={prod.salesProdId} className="glass-card p-0 animate-fade-up" style={{ minHeight: '400px' }}>
                <div style={{ height: '240px', background: 'var(--bg-secondary)', position: 'relative', overflow: 'hidden' }}>
                  <div style={{ position: 'absolute', top: '1rem', right: '1rem', zIndex: 1 }}>
                    <span className="badge" style={{ background: 'var(--accent)', padding: '0.4rem 0.8rem', borderRadius: '8px', fontSize: '0.7rem', fontWeight: 700 }}>PREMIUM</span>
                  </div>
                  <div style={{ width: '100%', height: '100%', background: `linear-gradient(45deg, var(--bg-secondary), var(--card-bg))` }}></div>
                </div>
                <div className="p-4">
                  <h4 className="mb-2" style={{ fontSize: '1.25rem' }}>{prod.salesProdName}</h4>
                  <p className="text-muted small mb-4" style={{ height: '3rem', overflow: 'hidden' }}>
                    {prod.description || '최상의 원재료로 완성된 프리미엄 육류 상품입니다. 맛팜이 보증하는 신선함을 경험하세요.'}
                  </p>
                  
                  <div className="d-flex justify-content-between align-items-end">
                    <div>
                      <div className="text-muted tiny mb-1" style={{ fontSize: '0.65rem', opacity: 0.7 }}>TOTAL PRICE (VAT INCL.)</div>
                      <div className="fw-bold" style={{ fontSize: '1.6rem', color: 'var(--text-main)' }}>
                        {new Intl.NumberFormat().format(prod.totalPrice)}<span style={{ fontSize: '0.9rem', marginLeft: '2px' }}>원</span>
                      </div>
                    </div>
                    <button 
                      className="btn-primary" 
                      style={{ padding: '0.6rem 1.5rem', borderRadius: '12px' }}
                      onClick={() => handlePurchase(prod)}
                    >
                      구매하기
                    </button>
                  </div>
                  
                  <div className="mt-4 pt-3 border-top" style={{ borderColor: 'var(--card-border)', fontSize: '0.75rem', display: 'flex', justifyContent: 'space-between', opacity: 0.5 }}>
                    <span>공급가: {new Intl.NumberFormat().format(prod.supplyPrice)}원</span>
                    <span>부가세: {new Intl.NumberFormat().format(prod.vatAmt)}원</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>

      <style>{`
        .tiny { font-size: 0.6rem; text-transform: uppercase; letter-spacing: 1px; }
        .badge { color: white; box-shadow: 0 4px 10px var(--accent-glow); }
      `}</style>
    </div>
  );

  async function handlePurchase(product) {
    if (memberMoney < product.totalPrice) {
      alert(`잔액이 부족합니다.\n현재 잔액: ${new Intl.NumberFormat().format(memberMoney)}원\n필요 금액: ${new Intl.NumberFormat().format(product.totalPrice)}원`);
      return;
    }

    if (!confirm(`[${product.salesProdName}]\n결제 금액: ${new Intl.NumberFormat().format(product.totalPrice)}원\n미트머니로 결제하시겠습니까?`)) {
      return;
    }

    try {
      const response = await fetch('http://localhost:8080/api/buyer/order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          totalAmount: product.totalPrice,
          orderTitle: product.salesProdName
        })
      });

      const result = await response.json();
      if (result.status === 'success') {
        alert('결제가 완료되었습니다!\n주문번호: ' + result.orderNo);
        // Refresh money balance
        window.location.reload();
      } else {
        alert('결제 실패: ' + result.message);
      }
    } catch (err) {
      console.error("Order failed:", err);
      alert('서버 통신 중 오류가 발생했습니다.');
    }
  }
}

export default App;
