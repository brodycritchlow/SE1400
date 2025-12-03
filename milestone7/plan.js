function addToPlan(name, type, image) {
    const plan = JSON.parse(localStorage.getItem('weddingPlan')) || [];

    const exists = plan.some(item => item.name === name);

    plan.push({ name, type, image });
    localStorage.setItem('weddingPlan', JSON.stringify(plan));
    alert('Added to your plan!');
}

function loadPlan() {
    const plan = JSON.parse(localStorage.getItem('weddingPlan')) || [];
    const container = document.getElementById('plan-items');

    container.innerHTML = '<div class="grid-container"></div>';
    const gridContainer = container.querySelector('.grid-container');

    plan.forEach((item, index) => {
        const itemDiv = document.createElement('div');
        itemDiv.className = 'grid-item';
        itemDiv.innerHTML = `
            <img src="${item.image}" alt="${item.name}">
            <h3>${item.name}</h3>
            <p class="item-type">${item.type}</p>
            <button class="btn-delete" onclick="removeFromPlan(${index})">Remove</button>
        `;
        gridContainer.appendChild(itemDiv);
    });
}

function removeFromPlan(index) {
    const plan = JSON.parse(localStorage.getItem('weddingPlan')) || [];
    plan.splice(index, 1);
    localStorage.setItem('weddingPlan', JSON.stringify(plan));
    loadPlan();
}

if (document.getElementById('plan-items')) {
    loadPlan();
}
