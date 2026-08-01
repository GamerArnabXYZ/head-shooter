local constants = require("game.constants")

local M = {}

function M.cols_in_row(row)
	if row % 2 == 1 then
		return constants.COLS_WIDE
	else
		return constants.COLS_NARROW
	end
end

function M.cell_to_pos(row, col)
	local x
	if row % 2 == 1 then
		x = constants.GRID_LEFT_X + (col - 1) * constants.CELL
	else
		x = constants.GRID_LEFT_X + constants.RADIUS + (col - 1) * constants.CELL
	end
	local y = constants.GRID_TOP_Y - (row - 1) * constants.ROW_H
	return x, y
end

function M.neighbors(row, col)
	local n = {}
	table.insert(n, {row, col - 1})
	table.insert(n, {row, col + 1})
	if row % 2 == 1 then
		table.insert(n, {row - 1, col - 1})
		table.insert(n, {row - 1, col})
		table.insert(n, {row + 1, col - 1})
		table.insert(n, {row + 1, col})
	else
		table.insert(n, {row - 1, col})
		table.insert(n, {row - 1, col + 1})
		table.insert(n, {row + 1, col})
		table.insert(n, {row + 1, col + 1})
	end
	return n
end

function M.in_bounds(row, col)
	if row < 1 then
		return false
	end
	local cols = M.cols_in_row(row)
	return col >= 1 and col <= cols
end

-- Find the nearest empty cell to a world position, searching nearby rows only
-- (fast enough for the small grids used here; avoids scanning the whole grid).
function M.nearest_cell(grid, x, y)
	local best_row, best_col, best_d = nil, nil, math.huge
	local approx_row = math.floor((constants.GRID_TOP_Y - y) / constants.ROW_H + 0.5) + 1
	if approx_row < 1 then
		approx_row = 1
	end
	for row = math.max(1, approx_row - 2), approx_row + 2 do
		local cols = M.cols_in_row(row)
		for col = 1, cols do
			local occupied = grid[row] ~= nil and grid[row][col] ~= nil
			if not occupied then
				local cx, cy = M.cell_to_pos(row, col)
				local dx, dy = cx - x, cy - y
				local d = dx * dx + dy * dy
				if d < best_d then
					best_d = d
					best_row = row
					best_col = col
				end
			end
		end
	end
	return best_row, best_col
end

return M
