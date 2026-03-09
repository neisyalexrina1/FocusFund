<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>FocusFund Mode - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-focusfund">
                    <div class="settings-page-container">
                        <aside class="settings-sidebar">
                            <div class="settings-sidebar-header">
                                <a href="${pageContext.request.contextPath}/DashboardServlet" class="back-btn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 12H5M12 19l-7-7 7-7" />
                                    </svg>
                                    Back
                                </a>
                                <h2>FocusFund Mode</h2>
                            </div>
                            <nav class="settings-nav">
                                <button class="settings-nav-item active" onclick="switchFocusFundTab('about')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="10" />
                                        <path d="M12 16v-4M12 8h.01" />
                                    </svg>
                                    <span>About</span>
                                </button>
                                <button class="settings-nav-item" onclick="switchFocusFundTab('deposit')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="2" y="5" width="20" height="14" rx="2" />
                                        <path d="M12 9v6M9 12h6" />
                                    </svg>
                                    <span>Deposit</span>
                                </button>
                                <button class="settings-nav-item" onclick="switchFocusFundTab('withdraw')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <rect x="2" y="5" width="20" height="14" rx="2" />
                                        <path d="M9 12h6" />
                                    </svg>
                                    <span>Withdraw</span>
                                </button>
                                <button class="settings-nav-item" onclick="switchFocusFundTab('contract')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" />
                                        <path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" />
                                    </svg>
                                    <span>Contract</span>
                                </button>
                                <button class="settings-nav-item" onclick="switchFocusFundTab('history')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <circle cx="12" cy="12" r="10" />
                                        <path d="M12 6v6l4 2" />
                                    </svg>
                                    <span>History</span>
                                </button>
                                <button class="settings-nav-item" onclick="switchFocusFundTab('exchange')">
                                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M7 16V4m0 0L3 8m4-4l4 4M17 8v12m0 0l4-4m-4 4l-4-4" />
                                    </svg>
                                    <span>Coin Exchange</span>
                                </button>
                            </nav>
                        </aside>

                        <main class="settings-content">
                            <!-- About Tab -->
                            <div class="focusfund-tab active" id="focusfund-tab-about">
                                <div class="account-tab-header">
                                    <h1>✨ What is FocusFund Mode?</h1>
                                    <p>A unique study commitment feature with a charitable twist</p>
                                </div>
                                <!-- Balance Card -->
                                <div class="account-section">
                                    <div class="current-balance-card"
                                        style="background:linear-gradient(135deg,rgba(99,102,241,0.15),rgba(168,85,247,0.15)); border:1px solid rgba(99,102,241,0.2); border-radius:16px; padding:24px; display:flex; align-items:center; gap:16px; margin-bottom:24px;">
                                        <span style="font-size:2.5rem;">💰</span>
                                        <div>
                                            <span
                                                style="display:block; font-size:0.85rem; color:var(--color-text-secondary);">Current
                                                Balance</span>
                                            <span id="mainBalance"
                                                style="font-size:1.8rem; font-weight:700; color:white;">Loading...</span>
                                        </div>
                                    </div>
                                    <div class="focusfund-info-card">
                                        <h3>🎯 How it works</h3>
                                        <p>FocusFund Mode is a voluntary commitment system. Deposit money as your "focus
                                            stake" — if you become distracted during study, a portion goes to charity.
                                        </p>
                                    </div>
                                    <div class="focusfund-info-card" style="margin-top:var(--spacing-lg);">
                                        <h3>💝 For Charity</h3>
                                        <p>All collected funds go directly to verified charitable organizations helping
                                            education initiatives worldwide.</p>
                                    </div>
                                    <div class="focusfund-info-card" style="margin-top:var(--spacing-lg);">
                                        <h3>🆓 Completely Voluntary</h3>
                                        <p>100% optional. Designed for extra motivation through "loss aversion"
                                            psychology.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Deposit Tab -->
                            <div class="focusfund-tab" id="focusfund-tab-deposit">
                                <div class="account-tab-header">
                                    <h1>💰 Deposit Funds</h1>
                                    <p>Add funds to your FocusFund balance</p>
                                </div>
                                <div class="account-section">
                                    <div class="current-balance-card"
                                        style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); border-radius:16px; padding:20px; display:flex; align-items:center; gap:16px; margin-bottom:20px;">
                                        <span style="font-size:2rem;">💰</span>
                                        <div>
                                            <span
                                                style="display:block; font-size:0.8rem; color:var(--color-text-secondary);">Current
                                                Balance</span>
                                            <span id="depositBalance"
                                                style="font-size:1.5rem; font-weight:700; color:white;">--</span>
                                        </div>
                                    </div>
                                    <div style="display:flex; flex-direction:column; gap:16px;">
                                        <div>
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:6px;">Amount
                                                (VND)</label>
                                            <input type="number" id="depositAmount" class="input" placeholder="100000"
                                                min="10000" step="10000"
                                                style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:14px 16px;">
                                        </div>
                                        <div style="display:flex; gap:8px; flex-wrap:wrap;">
                                            <button onclick="document.getElementById('depositAmount').value=50000"
                                                style="padding:8px 16px; border-radius:10px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-primary); cursor:pointer;">50K</button>
                                            <button onclick="document.getElementById('depositAmount').value=100000"
                                                style="padding:8px 16px; border-radius:10px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-primary); cursor:pointer;">100K</button>
                                            <button onclick="document.getElementById('depositAmount').value=200000"
                                                style="padding:8px 16px; border-radius:10px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-primary); cursor:pointer;">200K</button>
                                            <button onclick="document.getElementById('depositAmount').value=500000"
                                                style="padding:8px 16px; border-radius:10px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-primary); cursor:pointer;">500K</button>
                                        </div>
                                        <button id="depositBtn" onclick="doDeposit()" class="btn btn-primary"
                                            style="padding:14px; border-radius:12px; font-weight:600; font-size:1rem;">Confirm
                                            Deposit 💰</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Withdraw Tab -->
                            <div class="focusfund-tab" id="focusfund-tab-withdraw">
                                <div class="account-tab-header">
                                    <h1>💸 Withdraw Funds</h1>
                                    <p>Transfer your balance to your bank account</p>
                                </div>
                                <div class="account-section">
                                    <div class="current-balance-card"
                                        style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); border-radius:16px; padding:20px; display:flex; align-items:center; gap:16px; margin-bottom:20px;">
                                        <span style="font-size:2rem;">💸</span>
                                        <div>
                                            <span
                                                style="display:block; font-size:0.8rem; color:var(--color-text-secondary);">Available
                                                for Withdrawal</span>
                                            <span id="withdrawBalance"
                                                style="font-size:1.5rem; font-weight:700; color:white;">--</span>
                                        </div>
                                    </div>
                                    <div style="display:flex; flex-direction:column; gap:16px;">
                                        <div>
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:6px;">Amount
                                                (VND)</label>
                                            <input type="number" id="withdrawAmount" class="input" placeholder="100000"
                                                min="10000" step="10000"
                                                style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:14px 16px;">
                                        </div>
                                        <div>
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:8px;">Withdrawal
                                                Method</label>
                                            <div style="display:flex; flex-direction:column; gap:8px;">
                                                <label
                                                    style="display:flex; align-items:center; gap:10px; padding:12px 16px; border:1px solid rgba(255,255,255,0.08); border-radius:12px; cursor:pointer;">
                                                    <input type="radio" name="withdrawMethod" value="visa" checked>
                                                    <span>💳</span> <span>Visa/Mastercard/PayPal</span>
                                                </label>
                                                <label
                                                    style="display:flex; align-items:center; gap:10px; padding:12px 16px; border:1px solid rgba(255,255,255,0.08); border-radius:12px; cursor:pointer;">
                                                    <input type="radio" name="withdrawMethod" value="momo">
                                                    <span>📱</span> <span>MoMo E-Wallet</span>
                                                </label>
                                                <label
                                                    style="display:flex; align-items:center; gap:10px; padding:12px 16px; border:1px solid rgba(255,255,255,0.08); border-radius:12px; cursor:pointer;">
                                                    <input type="radio" name="withdrawMethod" value="vnpay">
                                                    <span>🏦</span> <span>VNPay Bank Transfer</span>
                                                </label>
                                            </div>
                                        </div>
                                        <button id="withdrawBtn" onclick="doWithdraw()" class="btn btn-primary"
                                            style="padding:14px; border-radius:12px; font-weight:600; font-size:1rem;">Confirm
                                            Withdrawal 💸</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Contract Tab -->
                            <div class="focusfund-tab" id="focusfund-tab-contract">
                                <div class="account-tab-header">
                                    <h1>📋 Focus Contract</h1>
                                    <p>Stake money to stay focused — lose a percentage if you slack off</p>
                                </div>
                                <div class="account-section">
                                    <!-- Active Contract Display -->
                                    <div id="activeContractPanel" style="margin-bottom:24px;"></div>

                                    <!-- Create Contract Form -->
                                    <div id="createContractSection">
                                        <h3 style="color:var(--color-text-primary); margin-bottom:16px;">Create New
                                            Contract</h3>
                                        <div style="display:flex; flex-direction:column; gap:16px;">
                                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                                <div>
                                                    <label
                                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Stake
                                                        Amount (VND)</label>
                                                    <input type="number" id="stakeAmount" class="input"
                                                        placeholder="100000" min="10000" step="10000"
                                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                                </div>
                                                <div>
                                                    <label
                                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Penalty
                                                        %</label>
                                                    <select id="penaltyPercent" class="input"
                                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; appearance:none;">
                                                        <option value="5" style="background:#1a1d2d;">5% (Easy)</option>
                                                        <option value="10" selected style="background:#1a1d2d;">10%
                                                            (Normal)</option>
                                                        <option value="20" style="background:#1a1d2d;">20% (Hard)
                                                        </option>
                                                        <option value="50" style="background:#1a1d2d;">50% (Extreme)
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px;">
                                                <div>
                                                    <label
                                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Goal
                                                        Type</label>
                                                    <select id="goalType" class="input"
                                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; appearance:none;">
                                                        <option value="session" style="background:#1a1d2d;">Min per
                                                            Session</option>
                                                        <option value="daily" style="background:#1a1d2d;">Min per Day
                                                        </option>
                                                    </select>
                                                </div>
                                                <div>
                                                    <label
                                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Goal
                                                        Value (min)</label>
                                                    <input type="number" id="goalValue" class="input" value="25" min="1"
                                                        max="120"
                                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                                </div>
                                                <div>
                                                    <label
                                                        style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Duration
                                                        (days)</label>
                                                    <input type="number" id="durationDays" class="input" value="7"
                                                        min="1" max="30"
                                                        style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                                                </div>
                                            </div>
                                            <button id="createContractBtn" onclick="createContract()"
                                                class="btn btn-primary"
                                                style="padding:14px; border-radius:12px; font-weight:600;">Create
                                                Contract 📋</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- History Tab -->
                            <div class="focusfund-tab" id="focusfund-tab-history">
                                <div class="account-tab-header">
                                    <h1>📜 Transaction History</h1>
                                    <p>Your FocusFund transaction records</p>
                                </div>
                                <div class="account-section">
                                    <div id="transactionsList" style="display:flex; flex-direction:column; gap:8px;">
                                        <p style="color:var(--color-text-secondary);">Loading...</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Coin Exchange Tab -->
                            <div class="focusfund-tab" id="focusfund-tab-exchange">
                                <div class="account-tab-header">
                                    <h1>🪙 Coin Exchange</h1>
                                    <p>Convert Focus Coins to VND balance</p>
                                </div>
                                <div class="account-section">
                                    <div
                                        style="background:rgba(255,255,255,0.03); border:1px solid rgba(255,255,255,0.08); border-radius:16px; padding:20px; margin-bottom:20px;">
                                        <div style="display:flex; justify-content:space-between; align-items:center;">
                                            <div>
                                                <div style="font-size:0.8rem; color:var(--color-text-secondary);">Your
                                                    Focus Coins</div>
                                                <div id="coinBalance"
                                                    style="font-size:1.5rem; font-weight:700; color:#fbbf24;">-- 🪙
                                                </div>
                                            </div>
                                            <div style="font-size:0.8rem; color:var(--color-text-secondary);">Rate: 1
                                                coin = 100 VND</div>
                                        </div>
                                    </div>
                                    <div style="display:flex; flex-direction:column; gap:16px;">
                                        <div>
                                            <label
                                                style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:6px;">Coins
                                                to Exchange</label>
                                            <input type="number" id="exchangeCoins" class="input" placeholder="100"
                                                min="1"
                                                style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:12px; padding:14px 16px;">
                                        </div>
                                        <button onclick="exchangeCoins()" class="btn btn-primary"
                                            style="padding:14px; border-radius:12px; font-weight:600;">Exchange Coins
                                            🪙→💰</button>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </section>

                <!-- Toast -->
                <div class="toast-container" id="toastContainer"></div>

                <%@ include file="common/footer.jsp" %>

                    <style>
                        .toast-container {
                            position: fixed;
                            bottom: 24px;
                            right: 24px;
                            z-index: 9999;
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }

                        .toast {
                            padding: 12px 20px;
                            border-radius: 12px;
                            color: #fff;
                            font-size: 0.9rem;
                            font-weight: 500;
                            animation: toastSlideIn 0.3s ease, toastFadeOut 0.3s ease 2.7s forwards;
                            max-width: 360px;
                        }

                        .toast-success {
                            background: rgba(34, 197, 94, 0.9);
                        }

                        .toast-error {
                            background: rgba(239, 68, 68, 0.9);
                        }

                        @keyframes toastSlideIn {
                            from {
                                transform: translateX(100%);
                                opacity: 0;
                            }

                            to {
                                transform: translateX(0);
                                opacity: 1;
                            }
                        }

                        @keyframes toastFadeOut {
                            from {
                                opacity: 1;
                            }

                            to {
                                opacity: 0;
                            }
                        }

                        .txn-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 12px 16px;
                            background: rgba(255, 255, 255, 0.02);
                            border: 1px solid rgba(255, 255, 255, 0.06);
                            border-radius: 12px;
                        }

                        .txn-amount.positive {
                            color: #22c55e;
                        }

                        .txn-amount.negative {
                            color: #ef4444;
                        }
                    </style>

                    <script>
                        var ctx = '${pageContext.request.contextPath}';

                        function showToast(msg, type) {
                            var c = document.getElementById('toastContainer');
                            if (!c) return;
                            var t = document.createElement('div');
                            t.className = 'toast toast-' + (type || 'info');
                            t.textContent = msg;
                            c.appendChild(t);
                            setTimeout(function () { t.remove(); }, 3000);
                        }

                        function switchFocusFundTab(tab) {
                            document.querySelectorAll('.settings-nav-item').forEach(function (btn) { btn.classList.remove('active'); });
                            document.querySelectorAll('.focusfund-tab').forEach(function (t) { t.classList.remove('active'); });
                            event.target.closest('.settings-nav-item').classList.add('active');
                            var el = document.getElementById('focusfund-tab-' + tab);
                            if (el) el.classList.add('active');

                            if (tab === 'history') loadTransactions();
                            if (tab === 'contract') loadActiveContract();
                            if (tab === 'exchange') loadCoinBalance();
                        }

                        function updateAllBalances(balance) {
                            var formatted = Number(balance).toLocaleString('vi-VN') + ' VND';
                            document.getElementById('mainBalance').textContent = formatted;
                            document.getElementById('depositBalance').textContent = formatted;
                            document.getElementById('withdrawBalance').textContent = formatted;
                        }

                        // Load initial balance
                        fetch(ctx + '/FocusFundServlet?action=balance')
                            .then(function (r) { return r.json(); })
                            .then(function (data) { updateAllBalances(data.balance || 0); })
                            .catch(function () { updateAllBalances(0); });

                        // Deposit
                        function doDeposit() {
                            var amount = document.getElementById('depositAmount').value;
                            if (!amount || amount < 10000) { showToast('Minimum deposit is 10,000 VND', 'error'); return; }
                            var btn = document.getElementById('depositBtn');
                            btn.disabled = true; btn.textContent = 'Processing...';

                            fetch(ctx + '/FocusFundServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=deposit&amount=' + amount
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Deposit successful!', 'success');
                                        updateAllBalances(data.balance || 0);
                                        document.getElementById('depositAmount').value = '';
                                    } else showToast(data.error || 'Deposit failed', 'error');
                                    btn.disabled = false; btn.textContent = 'Confirm Deposit 💰';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Confirm Deposit 💰'; });
                        }

                        // Withdraw
                        function doWithdraw() {
                            var amount = document.getElementById('withdrawAmount').value;
                            if (!amount || amount < 10000) { showToast('Minimum withdrawal is 10,000 VND', 'error'); return; }
                            var btn = document.getElementById('withdrawBtn');
                            btn.disabled = true; btn.textContent = 'Processing...';

                            fetch(ctx + '/FocusFundServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=withdraw&amount=' + amount
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Withdrawal successful!', 'success');
                                        updateAllBalances(data.balance || 0);
                                        document.getElementById('withdrawAmount').value = '';
                                    } else showToast(data.error || 'Withdrawal failed', 'error');
                                    btn.disabled = false; btn.textContent = 'Confirm Withdrawal 💸';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Confirm Withdrawal 💸'; });
                        }

                        // Contract
                        function loadActiveContract() {
                            fetch(ctx + '/FocusFundServlet?action=activeContract')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    var panel = document.getElementById('activeContractPanel');
                                    if (data.hasContract && data.contract) {
                                        var c = data.contract;
                                        panel.innerHTML = '<div style="background:linear-gradient(135deg,rgba(34,197,94,0.1),rgba(16,185,129,0.1)); border:1px solid rgba(34,197,94,0.2); border-radius:16px; padding:20px;">'
                                            + '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;"><h4 style="color:#22c55e; margin:0;">✅ Active Contract</h4><span style="font-size:0.8rem; color:var(--color-text-secondary);">Status: ' + (c.status || 'active') + '</span></div>'
                                            + '<div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:12px; font-size:0.85rem;">'
                                            + '<div><div style="color:var(--color-text-secondary);">Staked</div><div style="color:white; font-weight:600;">' + Number(c.stakeAmount || 0).toLocaleString() + ' VND</div></div>'
                                            + '<div><div style="color:var(--color-text-secondary);">Penalty</div><div style="color:white; font-weight:600;">' + (c.penaltyPercent || 10) + '%</div></div>'
                                            + '<div><div style="color:var(--color-text-secondary);">Goal</div><div style="color:white; font-weight:600;">' + (c.goalValue || 25) + ' min/' + (c.goalType || 'session') + '</div></div>'
                                            + '</div></div>';
                                        document.getElementById('createContractSection').style.display = 'none';
                                    } else {
                                        panel.innerHTML = '<div style="text-align:center; padding:16px; color:var(--color-text-secondary); font-size:0.9rem;">No active contract. Create one below to boost your focus! 🚀</div>';
                                        document.getElementById('createContractSection').style.display = 'block';
                                    }
                                })
                                .catch(function () { });
                        }

                        function createContract() {
                            var btn = document.getElementById('createContractBtn');
                            btn.disabled = true; btn.textContent = 'Creating...';

                            var params = 'action=createContract'
                                + '&stakeAmount=' + document.getElementById('stakeAmount').value
                                + '&penaltyPercent=' + document.getElementById('penaltyPercent').value
                                + '&goalType=' + document.getElementById('goalType').value
                                + '&goalValue=' + document.getElementById('goalValue').value
                                + '&durationDays=' + document.getElementById('durationDays').value;

                            fetch(ctx + '/FocusFundServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: params
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Contract created!', 'success');
                                        updateAllBalances(data.balance || 0);
                                        loadActiveContract();
                                    } else showToast(data.error || 'Failed', 'error');
                                    btn.disabled = false; btn.textContent = 'Create Contract 📋';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Create Contract 📋'; });
                        }

                        // Transactions
                        function loadTransactions() {
                            fetch(ctx + '/FocusFundServlet?action=transactions&limit=20')
                                .then(function (r) { return r.json(); })
                                .then(function (txns) {
                                    var div = document.getElementById('transactionsList');
                                    if (!txns || txns.length === 0) {
                                        div.innerHTML = '<p style="color:var(--color-text-secondary); text-align:center; padding:20px;">No transactions yet</p>';
                                        return;
                                    }
                                    var html = '';
                                    txns.forEach(function (t) {
                                        var isPositive = t.amount > 0 || t.type === 'deposit' || t.transactionType === 'DEPOSIT';
                                        html += '<div class="txn-item">'
                                            + '<div><div style="color:var(--color-text-primary); font-weight:500;">' + (t.transactionType || t.type || 'Transaction') + '</div>'
                                            + '<div style="font-size:0.8rem; color:var(--color-text-muted);">' + (t.description || '') + '</div></div>'
                                            + '<div class="txn-amount ' + (isPositive ? 'positive' : 'negative') + '" style="font-weight:600;">' + (isPositive ? '+' : '') + Number(t.amount || 0).toLocaleString() + ' VND</div>'
                                            + '</div>';
                                    });
                                    div.innerHTML = html;
                                })
                                .catch(function () { document.getElementById('transactionsList').innerHTML = '<p style="color:var(--color-text-secondary);">Could not load transactions</p>'; });
                        }

                        // Coin Exchange
                        function loadCoinBalance() {
                            fetch(ctx + '/GamificationServlet?action=profile')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    document.getElementById('coinBalance').textContent = (data.focusCoins || 0) + ' 🪙';
                                })
                                .catch(function () { });
                        }

                        function exchangeCoins() {
                            var coins = document.getElementById('exchangeCoins').value;
                            if (!coins || coins < 1) { showToast('Enter coins to exchange', 'error'); return; }

                            fetch(ctx + '/FocusFundServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=exchangeCoins&coins=' + coins
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast(data.message || 'Coins exchanged!', 'success');
                                        if (data.balance !== undefined) updateAllBalances(data.balance);
                                        loadCoinBalance();
                                        document.getElementById('exchangeCoins').value = '';
                                    } else showToast(data.error || 'Exchange failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // Init
                        loadActiveContract();
                    </script>
        </body>

        </html>