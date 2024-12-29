<script>
	import Chat from '$lib/components/chat/Chat.svelte';

	let isResizingHorizontal = false;
	let isResizingVertical = false;
	let startX = 0;
	let startY = 0;
	let containerWidth = 0;
	let containerHeight = 0;
	let leftWidth = 50; // Width in percentage
	let topHeight = 50; // Height in percentage

	// Horizontal Resize Handlers (for left and right panels)
	function startResizeHorizontal(event) {
		isResizingHorizontal = true;
		startX = event.clientX;
		containerWidth = document.querySelector('.resizable-container').offsetWidth;
		document.addEventListener('mousemove', resizeHorizontal);
		document.addEventListener('mouseup', stopResizeHorizontal);
	}

	function resizeHorizontal(event) {
		if (!isResizingHorizontal) return;
		const dx = event.clientX - startX;
		const newWidth = leftWidth + (dx / containerWidth) * 100;
		if (newWidth >= 20 && newWidth <= 80) {
			leftWidth = newWidth;
		}
		startX = event.clientX;
	}

	function stopResizeHorizontal() {
		isResizingHorizontal = false;
		document.removeEventListener('mousemove', resizeHorizontal);
		document.removeEventListener('mouseup', stopResizeHorizontal);
	}

	// Vertical Resize Handlers (for top and bottom sections in left panel)
	function startResizeVertical(event) {
		isResizingVertical = true;
		startY = event.clientY;
		containerHeight = document.querySelector('.left-panel-container').offsetHeight;
		document.addEventListener('mousemove', resizeVertical);
		document.addEventListener('mouseup', stopResizeVertical);
	}

	function resizeVertical(event) {
		if (!isResizingVertical) return;
		const dy = event.clientY - startY;
		const newHeight = topHeight + (dy / containerHeight) * 100;
		if (newHeight >= 20 && newHeight <= 80) {
			topHeight = newHeight;
		}
		startY = event.clientY;
	}

	function stopResizeVertical() {
		isResizingVertical = false;
		document.removeEventListener('mousemove', resizeVertical);
		document.removeEventListener('mouseup', stopResizeVertical);
	}
</script>

<div class="resizable-container">
	<div class="left-panel" style:width={leftWidth + '%'}>
		<!-- Left Panel Content -->
		<div class="left-panel-container" style="height: 100%;">
			<!-- Top Section -->
			<div class="top-section" style:height={topHeight + '%'}>
				<!-- Place top content here -->
				<Chat />
			</div>
			<!-- Vertical Separator -->
			<div
				class="vertical-separator"
				on:mousedown={startResizeVertical}
				on:touchstart={startResizeVertical}
				on:touchmove={resizeVertical}
				on:touchend={stopResizeVertical}
			>
				<!-- Separator handle -->
			</div>
			<!-- Bottom Section -->
			<div class="bottom-section" style:height={100 - topHeight + '%'}>
				<!-- Place bottom content here -->
				<div class="content">Bottom Section Content</div>
			</div>
		</div>
	</div>
	<!-- Horizontal Separator -->
	<div
		class="horizontal-separator"
		on:mousedown={startResizeHorizontal}
		on:touchstart={startResizeHorizontal}
		on:touchmove={resizeHorizontal}
		on:touchend={stopResizeHorizontal}
	>
		<!-- Separator handle -->
	</div>
	<div class="right-panel" style:width={100 - leftWidth + '%'}>
		<!-- Right Panel Content -->
		<div class="content">Right Component</div>
	</div>
</div>

<style>
	.resizable-container {
		display: flex;
		width: 100%;
		height: 100vh; /* Adjust as needed */
		overflow: hidden;
	}
	.left-panel,
	.right-panel {
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}
	.left-panel-container {
		display: flex;
		flex-direction: column;
		height: 100%;
	}
	.top-section,
	.bottom-section {
		overflow: auto;
		padding: 10px;
		box-sizing: border-box;
	}
	.vertical-separator {
		width: 100%;
		height: 1px; /* Height of the vertical separator */
		background-color: #ccc;
		cursor: ns-resize;
	}
	.horizontal-separator {
		width: 1px; /* Width of the horizontal separator */
		background-color: #ccc;
		cursor: ew-resize;
	}
	.content {
		width: 100%;
		text-align: left;
	}
</style>
