<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="AuthServlet" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <%@ include file="common/header.jsp" %>
                <title>Flashcards - FocusFund</title>
        </head>

        <body>
            <div class="background-effects">
                <div class="stars" id="stars"></div>
                <div class="shooting-stars" id="shooting-stars"></div>
                <div class="rain" id="rain"></div>
            </div>

            <%@ include file="common/navbar.jsp" %>

                <section class="page active" id="page-flashcards">
                    <div class="page-container">
                        <div class="page-header"
                            style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px;">
                            <div>
                                <h1 class="page-title">🃏 Flashcards</h1>
                                <p class="page-subtitle">Study smart with spaced repetition</p>
                            </div>
                            <button class="btn btn-primary"
                                onclick="document.getElementById('createDeckModal').classList.remove('hidden')"
                                style="display:flex; align-items:center; gap:8px;">
                                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19" />
                                    <line x1="5" y1="12" x2="19" y2="12" />
                                </svg>
                                Create Deck
                            </button>
                        </div>

                        <!-- Decks Grid -->
                        <div id="decksView">
                            <div id="decksGrid" class="rooms-grid"
                                style="grid-template-columns:repeat(auto-fill,minmax(280px,1fr));">
                                <p
                                    style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center; padding:40px;">
                                    Loading decks...</p>
                            </div>
                        </div>

                        <!-- Cards View (hidden by default) -->
                        <div id="cardsView" class="hidden">
                            <div style="display:flex; align-items:center; gap:12px; margin-bottom:var(--spacing-lg);">
                                <button onclick="backToDecks()"
                                    style="padding:8px 12px; border-radius:8px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-secondary); cursor:pointer;">←
                                    Back</button>
                                <h2 id="currentDeckName" style="color:var(--color-text-primary);"></h2>
                                <button class="btn btn-primary btn-sm"
                                    onclick="document.getElementById('addCardModal').classList.remove('hidden')"
                                    style="margin-left:auto;">+ Add Card</button>
                                <button id="reviewBtn" class="btn btn-sm" onclick="startReview()"
                                    style="padding:6px 16px; border-radius:8px; background:linear-gradient(135deg,#f59e0b,#ef4444); color:white; border:none; cursor:pointer; font-weight:600;">📖
                                    Review</button>
                            </div>
                            <div id="cardsList"
                                style="display:grid; grid-template-columns:repeat(auto-fill,minmax(250px,1fr)); gap:16px;">
                            </div>
                        </div>

                        <!-- Review Mode (hidden by default) -->
                        <div id="reviewView" class="hidden">
                            <div style="text-align:center; max-width:600px; margin:0 auto;">
                                <div
                                    style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
                                    <button onclick="exitReview()"
                                        style="padding:8px 12px; border-radius:8px; background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); color:var(--color-text-secondary); cursor:pointer;">←
                                        Exit Review</button>
                                    <span id="reviewCounter"
                                        style="color:var(--color-text-secondary); font-size:0.9rem;"></span>
                                </div>
                                <div id="flashcard"
                                    style="background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1); border-radius:20px; padding:60px 40px; min-height:200px; cursor:pointer; transition:all 0.3s; display:flex; flex-direction:column; align-items:center; justify-content:center;"
                                    onclick="flipCard()">
                                    <div id="cardFront"
                                        style="font-size:1.3rem; color:var(--color-text-primary); font-weight:600;">
                                    </div>
                                    <div id="cardBack" class="hidden"
                                        style="font-size:1.1rem; color:var(--color-text-secondary);"></div>
                                    <p id="flipHint"
                                        style="font-size:0.8rem; color:var(--color-text-muted); margin-top:20px;">Click
                                        to flip</p>
                                </div>
                                <div id="difficultyBtns" class="hidden"
                                    style="display:flex; justify-content:center; gap:12px; margin-top:20px;">
                                    <button onclick="recordReview('easy')"
                                        style="padding:10px 24px; border-radius:10px; background:rgba(34,197,94,0.15); color:#22c55e; border:1px solid rgba(34,197,94,0.3); cursor:pointer; font-weight:600;">😄
                                        Easy</button>
                                    <button onclick="recordReview('medium')"
                                        style="padding:10px 24px; border-radius:10px; background:rgba(59,130,246,0.15); color:#60a5fa; border:1px solid rgba(59,130,246,0.3); cursor:pointer; font-weight:600;">🤔
                                        Medium</button>
                                    <button onclick="recordReview('hard')"
                                        style="padding:10px 24px; border-radius:10px; background:rgba(239,68,68,0.15); color:#f87171; border:1px solid rgba(239,68,68,0.3); cursor:pointer; font-weight:600;">😰
                                        Hard</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Create Deck Modal -->
                <div class="modal-overlay hidden" id="createDeckModal">
                    <div class="modal-overlay-bg"
                        onclick="document.getElementById('createDeckModal').classList.add('hidden')"></div>
                    <div class="modal-content"
                        style="position:relative; z-index:1; background:#1a1d2d; border-radius:24px; max-width:480px; width:90%; box-shadow:0 25px 50px -12px rgba(0,0,0,0.5); border:1px solid rgba(255,255,255,0.1); padding:32px; transform:scale(0.95) translateY(10px); transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1);">
                        <div
                            style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h2 style="font-family:var(--font-display); font-size:1.3rem; color:white; margin:0;">🃏
                                Create Deck</h2>
                            <button onclick="document.getElementById('createDeckModal').classList.add('hidden')"
                                style="background:rgba(255,255,255,0.05); border:none; border-radius:50%; width:30px; height:30px; display:flex; align-items:center; justify-content:center; cursor:pointer; color:var(--color-text-secondary);">✕</button>
                        </div>
                        <form id="createDeckForm" style="display:flex; flex-direction:column; gap:16px;">
                            <div>
                                <label
                                    style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Deck
                                    Name <span style="color:#ef4444;">*</span></label>
                                <input type="text" id="deckName" class="input" placeholder="e.g., Biology Chapter 5"
                                    required
                                    style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                            </div>
                            <div>
                                <label
                                    style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Description</label>
                                <input type="text" id="deckDesc" class="input" placeholder="Optional description"
                                    style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px;">
                            </div>
                            <div
                                style="display:flex; justify-content:flex-end; gap:10px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06);">
                                <button type="button"
                                    onclick="document.getElementById('createDeckModal').classList.add('hidden')"
                                    style="padding:8px 18px; border-radius:10px; background:transparent; color:var(--color-text-secondary); border:1px solid rgba(255,255,255,0.1); cursor:pointer;">Cancel</button>
                                <button type="submit" id="createDeckBtn"
                                    style="padding:8px 24px; border-radius:10px; background:linear-gradient(135deg,#6366f1,#a855f7); color:white; border:none; cursor:pointer; font-weight:600;">Create</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Add Card Modal -->
                <div class="modal-overlay hidden" id="addCardModal">
                    <div class="modal-overlay-bg"
                        onclick="document.getElementById('addCardModal').classList.add('hidden')"></div>
                    <div class="modal-content"
                        style="position:relative; z-index:1; background:#1a1d2d; border-radius:24px; max-width:500px; width:90%; box-shadow:0 25px 50px -12px rgba(0,0,0,0.5); border:1px solid rgba(255,255,255,0.1); padding:32px; transform:scale(0.95) translateY(10px); transition:all 0.3s cubic-bezier(0.34,1.56,0.64,1);">
                        <div
                            style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                            <h2 style="font-family:var(--font-display); font-size:1.3rem; color:white; margin:0;">➕ Add
                                Card</h2>
                            <button onclick="document.getElementById('addCardModal').classList.add('hidden')"
                                style="background:rgba(255,255,255,0.05); border:none; border-radius:50%; width:30px; height:30px; display:flex; align-items:center; justify-content:center; cursor:pointer; color:var(--color-text-secondary);">✕</button>
                        </div>
                        <form id="addCardForm" style="display:flex; flex-direction:column; gap:16px;">
                            <div>
                                <label
                                    style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Front
                                    (Question) <span style="color:#ef4444;">*</span></label>
                                <textarea id="cardFrontInput" class="input" rows="3" required
                                    placeholder="Enter the question or term..."
                                    style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; resize:none;"></textarea>
                            </div>
                            <div>
                                <label
                                    style="font-size:0.8rem; text-transform:uppercase; color:var(--color-text-secondary); display:block; margin-bottom:4px;">Back
                                    (Answer) <span style="color:#ef4444;">*</span></label>
                                <textarea id="cardBackInput" class="input" rows="3" required
                                    placeholder="Enter the answer..."
                                    style="background:rgba(0,0,0,0.2); border:1px solid rgba(255,255,255,0.1); border-radius:10px; padding:10px 14px; resize:none;"></textarea>
                            </div>
                            <div
                                style="display:flex; justify-content:flex-end; gap:10px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06);">
                                <button type="button"
                                    onclick="document.getElementById('addCardModal').classList.add('hidden')"
                                    style="padding:8px 18px; border-radius:10px; background:transparent; color:var(--color-text-secondary); border:1px solid rgba(255,255,255,0.1); cursor:pointer;">Cancel</button>
                                <button type="submit" id="addCardBtn"
                                    style="padding:8px 24px; border-radius:10px; background:linear-gradient(135deg,#10b981,#06b6d4); color:white; border:none; cursor:pointer; font-weight:600;">Add
                                    Card</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Toast -->
                <div class="toast-container" id="toastContainer"></div>

                <%@ include file="common/footer.jsp" %>

                    <style>
                        .modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            z-index: 1000;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            opacity: 0;
                            visibility: hidden;
                            transition: all 0.3s ease;
                        }

                        .modal-overlay:not(.hidden) {
                            opacity: 1;
                            visibility: visible;
                        }

                        .modal-overlay:not(.hidden) .modal-content {
                            transform: scale(1) translateY(0);
                        }

                        .modal-overlay-bg {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.6);
                            backdrop-filter: blur(8px);
                        }

                        .hidden {
                            display: none !important;
                        }

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

                        .deck-card {
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.08);
                            border-radius: 16px;
                            padding: 24px;
                            cursor: pointer;
                            transition: all 0.2s;
                            position: relative;
                        }

                        .deck-card:hover {
                            background: rgba(255, 255, 255, 0.06);
                            border-color: rgba(255, 255, 255, 0.12);
                            transform: translateY(-2px);
                        }

                        .deck-delete {
                            position: absolute;
                            top: 12px;
                            right: 12px;
                            background: rgba(239, 68, 68, 0.15);
                            border: none;
                            border-radius: 50%;
                            width: 28px;
                            height: 28px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            color: #f87171;
                            font-size: 0.8rem;
                            opacity: 0;
                            transition: all 0.2s;
                        }

                        .deck-card:hover .deck-delete {
                            opacity: 1;
                        }

                        .fc-card {
                            background: rgba(255, 255, 255, 0.03);
                            border: 1px solid rgba(255, 255, 255, 0.08);
                            border-radius: 12px;
                            padding: 16px;
                            position: relative;
                        }

                        .fc-card-delete {
                            position: absolute;
                            top: 8px;
                            right: 8px;
                            background: rgba(239, 68, 68, 0.15);
                            border: none;
                            border-radius: 50%;
                            width: 24px;
                            height: 24px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            color: #f87171;
                            font-size: 0.7rem;
                            opacity: 0;
                            transition: all 0.2s;
                        }

                        .fc-card:hover .fc-card-delete {
                            opacity: 1;
                        }
                    </style>

                    <script>
                        var ctx = '${pageContext.request.contextPath}';
                        var currentDeckId = null;
                        var reviewCards = [];
                        var reviewIndex = 0;
                        var isFlipped = false;

                        function showToast(msg, type) {
                            var c = document.getElementById('toastContainer');
                            if (!c) return;
                            var t = document.createElement('div');
                            t.className = 'toast toast-' + (type || 'info');
                            t.textContent = msg;
                            c.appendChild(t);
                            setTimeout(function () { t.remove(); }, 3000);
                        }

                        // ==================== DECKS ====================
                        function loadDecks() {
                            fetch(ctx + '/FlashcardServlet?action=myDecks')
                                .then(function (r) { return r.json(); })
                                .then(function (decks) {
                                    var grid = document.getElementById('decksGrid');
                                    if (!decks || decks.length === 0) {
                                        grid.innerHTML = '<div style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;"><div style="font-size:2.5rem; margin-bottom:8px;">🃏</div><p>No decks yet. Create your first one!</p></div>';
                                        return;
                                    }
                                    var html = '';
                                    decks.forEach(function (d) {
                                        html += '<div class="deck-card" onclick="openDeck(' + d.deckID + ', \'' + (d.deckName || '').replace(/'/g, "\\'") + '\')">'
                                            + '<button class="deck-delete" onclick="deleteDeck(' + d.deckID + ', event)" title="Delete">🗑</button>'
                                            + '<div style="font-size:2rem; margin-bottom:12px;">🃏</div>'
                                            + '<h3 style="color:var(--color-text-primary); font-size:1.05rem; margin-bottom:6px;">' + (d.deckName || 'Untitled') + '</h3>'
                                            + '<p style="color:var(--color-text-secondary); font-size:0.85rem; margin-bottom:12px;">' + (d.description || '') + '</p>'
                                            + '<div style="font-size:0.8rem; color:var(--color-text-muted);">📝 ' + (d.cardCount || 0) + ' cards</div>'
                                            + '</div>';
                                    });
                                    grid.innerHTML = html;
                                })
                                .catch(function () {
                                    document.getElementById('decksGrid').innerHTML = '<p style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center;">Could not load decks</p>';
                                });
                        }

                        // Create deck
                        document.getElementById('createDeckForm').addEventListener('submit', function (e) {
                            e.preventDefault();
                            var btn = document.getElementById('createDeckBtn');
                            btn.disabled = true; btn.textContent = 'Creating...';

                            fetch(ctx + '/FlashcardServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=createDeck&name=' + encodeURIComponent(document.getElementById('deckName').value) + '&description=' + encodeURIComponent(document.getElementById('deckDesc').value)
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast('Deck created!', 'success');
                                        document.getElementById('createDeckModal').classList.add('hidden');
                                        document.getElementById('createDeckForm').reset();
                                        loadDecks();
                                    } else showToast(data.error || 'Failed', 'error');
                                    btn.disabled = false; btn.textContent = 'Create';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Create'; });
                        });

                        function deleteDeck(deckId, event) {
                            event.stopPropagation();
                            if (!confirm('Delete this deck and all its cards?')) return;
                            fetch(ctx + '/FlashcardServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=deleteDeck&deckId=' + deckId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) { showToast('Deck deleted', 'success'); loadDecks(); }
                                    else showToast(data.error || 'Failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // ==================== CARDS ====================
                        function openDeck(deckId, name) {
                            currentDeckId = deckId;
                            document.getElementById('currentDeckName').textContent = name;
                            document.getElementById('decksView').classList.add('hidden');
                            document.getElementById('cardsView').classList.remove('hidden');
                            loadCards();
                        }

                        function backToDecks() {
                            currentDeckId = null;
                            document.getElementById('cardsView').classList.add('hidden');
                            document.getElementById('decksView').classList.remove('hidden');
                            loadDecks();
                        }

                        function loadCards() {
                            fetch(ctx + '/FlashcardServlet?action=cards&deckId=' + currentDeckId)
                                .then(function (r) { return r.json(); })
                                .then(function (cards) {
                                    var div = document.getElementById('cardsList');
                                    reviewCards = cards || [];
                                    if (reviewCards.length === 0) {
                                        div.innerHTML = '<div style="text-align:center; padding:40px; color:var(--color-text-secondary); grid-column:1/-1;"><p>No cards yet. Add your first card!</p></div>';
                                        return;
                                    }
                                    var html = '';
                                    reviewCards.forEach(function (c, i) {
                                        html += '<div class="fc-card">'
                                            + '<button class="fc-card-delete" onclick="deleteCard(' + c.cardID + ')" title="Delete">✕</button>'
                                            + '<div style="font-size:0.75rem; color:var(--color-text-muted); margin-bottom:6px;">Card #' + (i + 1) + '</div>'
                                            + '<div style="color:var(--color-text-primary); font-weight:500; margin-bottom:8px;">' + c.frontContent + '</div>'
                                            + '<div style="color:var(--color-text-secondary); font-size:0.9rem; border-top:1px solid rgba(255,255,255,0.06); padding-top:8px;">' + c.backContent + '</div>'
                                            + '</div>';
                                    });
                                    div.innerHTML = html;
                                })
                                .catch(function () {
                                    document.getElementById('cardsList').innerHTML = '<p style="color:var(--color-text-secondary); grid-column:1/-1; text-align:center;">Could not load cards</p>';
                                });
                        }

                        // Add card
                        document.getElementById('addCardForm').addEventListener('submit', function (e) {
                            e.preventDefault();
                            var btn = document.getElementById('addCardBtn');
                            btn.disabled = true; btn.textContent = 'Adding...';

                            fetch(ctx + '/FlashcardServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=addCard&deckId=' + currentDeckId
                                    + '&front=' + encodeURIComponent(document.getElementById('cardFrontInput').value)
                                    + '&back=' + encodeURIComponent(document.getElementById('cardBackInput').value)
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        showToast('Card added!', 'success');
                                        document.getElementById('addCardModal').classList.add('hidden');
                                        document.getElementById('addCardForm').reset();
                                        loadCards();
                                    } else showToast(data.error || 'Failed', 'error');
                                    btn.disabled = false; btn.textContent = 'Add Card';
                                })
                                .catch(function () { showToast('Network error', 'error'); btn.disabled = false; btn.textContent = 'Add Card'; });
                        });

                        function deleteCard(cardId) {
                            if (!confirm('Delete this card?')) return;
                            fetch(ctx + '/FlashcardServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=deleteCard&cardId=' + cardId
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) { showToast('Card deleted', 'success'); loadCards(); }
                                    else showToast(data.error || 'Failed', 'error');
                                })
                                .catch(function () { showToast('Network error', 'error'); });
                        }

                        // ==================== REVIEW ====================
                        function startReview() {
                            if (!reviewCards || reviewCards.length === 0) {
                                showToast('No cards to review! Add some first.', 'error');
                                return;
                            }
                            reviewIndex = 0;
                            isFlipped = false;
                            document.getElementById('cardsView').classList.add('hidden');
                            document.getElementById('reviewView').classList.remove('hidden');
                            showReviewCard();
                        }

                        function exitReview() {
                            document.getElementById('reviewView').classList.add('hidden');
                            document.getElementById('cardsView').classList.remove('hidden');
                        }

                        function showReviewCard() {
                            if (reviewIndex >= reviewCards.length) {
                                showToast('Review complete! 🎉', 'success');
                                exitReview();
                                return;
                            }
                            var card = reviewCards[reviewIndex];
                            document.getElementById('cardFront').textContent = card.frontContent;
                            document.getElementById('cardBack').textContent = card.backContent;
                            document.getElementById('cardBack').classList.add('hidden');
                            document.getElementById('flipHint').classList.remove('hidden');
                            document.getElementById('difficultyBtns').classList.add('hidden');
                            document.getElementById('reviewCounter').textContent = (reviewIndex + 1) + ' / ' + reviewCards.length;
                            isFlipped = false;
                        }

                        function flipCard() {
                            if (!isFlipped) {
                                isFlipped = true;
                                document.getElementById('cardBack').classList.remove('hidden');
                                document.getElementById('flipHint').classList.add('hidden');
                                document.getElementById('difficultyBtns').classList.remove('hidden');
                                document.getElementById('difficultyBtns').style.display = 'flex';
                            }
                        }

                        function recordReview(difficulty) {
                            var card = reviewCards[reviewIndex];
                            var diffMap = { 'easy': 1, 'medium': 2, 'hard': 3 };
                            var diffValue = diffMap[difficulty] || 2;
                            fetch(ctx + '/FlashcardServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                                body: 'action=recordReview&cardId=' + card.cardID + '&difficulty=' + diffValue
                            }).catch(function () { });

                            reviewIndex++;
                            showReviewCard();
                        }

                        // Init
                        loadDecks();
                    </script>
        </body>

        </html>