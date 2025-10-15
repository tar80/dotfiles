local M = {}

M.package_version = function()
  local ok, path = M.detect_marker(nyagos.getwd(), 'package.json')

  if ok then
    local version = nyagos.eval(string.format('cat %s\\package.json| jq -r ".version"', path))

    if version ~= 'null' then
      return string.format('$E[49;34mv%s ', version)
    end
  end

  return ''
end

return M
