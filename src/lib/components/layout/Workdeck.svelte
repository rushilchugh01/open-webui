<script>
	import Chat from '$lib/components/chat/Chat.svelte';

	let isResizing = false;
	let startX = 0;
	let containerWidth = 0;
	let leftWidth = 50; // Width in percentage

	function startResize(event) {
		isResizing = true;
		startX = event.clientX;
		containerWidth = document.querySelector('.resizable-container').offsetWidth;
		document.addEventListener('mousemove', resize);
		document.addEventListener('mouseup', stopResize);
	}

	function resize(event) {
		if (!isResizing) return;
		const dx = event.clientX - startX;
		const newWidth = leftWidth + (dx / containerWidth) * 100;
		// Set minimum width for both components, e.g., 20%
		if (newWidth >= 20 && newWidth <= 80) {
			leftWidth = newWidth;
		}
		startX = event.clientX;
	}

	function stopResize() {
		isResizing = false;
		document.removeEventListener('mousemove', resize);
		document.removeEventListener('mouseup', stopResize);
	}
</script>

<div class="resizable-container">
	<div class="left-panel" style:width={leftWidth + '%'}>
		<!-- Place your left component here -->
			<Chat />
	</div>
	<div
		class="separator"
		on:mousedown={startResize}
		on:touchstart={startResize}
		on:touchmove={resize}
		on:touchend={stopResize}
	>
		<!-- Separator handle -->
	</div>
	<div class="right-panel" style:width={100 - leftWidth + '%'}>
		<!-- Place your right component here -->
		<div class="content">Right Component</div>
	</div>
</div>

<style>
	.resizable-container {
		display: flex;
		width: 100%;
		overflow: hidden;
	}
	.left-panel,
	.right-panel {
		display: flex;
		justify-content: center;
		align-items: center;
		overflow: auto;
		padding: 10px;
		box-sizing: border-box; /* Include padding in the element's width */
	}
	.separator {
		width: 5px; /* Width of the separator */
		background-color: #ccc;
		cursor: ew-resize;
	}
	.content {
		width: 100%; /* Ensure content occupies full width of the pane */
		text-align: left; /* Center text horizontally */
	}
</style>
