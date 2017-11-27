defmodule Norma.Utils do
  @masked_ports ["443", "80", "8080", "21"]

  def port_handler(port) do
    case port do
      443  -> "https"
      80   -> "http"
      8080 -> "http"
      21   -> "ftp"
      _    -> "http"
    end
  end

  @doc """
  At first, I tried to do this with just the standard library
  ```
  "mazing.studio"
  |> URI.parse
  |> Map.put(:scheme, "http")
  |> URI.to_string

  > "http:mazing.studio"
  ```
  but the result wasn't what I expected.

  Help would be appreciated here to solve it better.
  """
  def form_url(%URI{host: host,
                    path: path,
                    scheme: scheme,
                    query: query,
                    port: port,
                    fragment: fragment}) do
    form_scheme(scheme)                         # "http://"
    |> safe_concat(host)                        # "http://google.com"
    |> Kernel.<>(form_port(port |> to_string))  # "http://google.com:1337"
    |> safe_concat(path)                        # "http://google.com:1337/test"
    |> Kernel.<>(form_fragment(fragment))       # "http://google.com:1337/test#cats"
    |> Kernel.<>(form_query(query))             # "http://google.com:1337/test#cats?dogs_allowed=ño"
  end

  defp form_scheme(""), do: ""
  defp form_scheme(scheme), do: scheme <> "://"

  defp form_fragment(nil), do: ""
  defp form_fragment(fragment), do: "#" <> fragment

  defp form_query(nil), do: ""
  defp form_query(query), do: "?" <> query

  defp form_port(""), do: ""
  defp form_port(port)
  when port not in @masked_ports, do: ":" <> port
  defp form_port(_port), do: ""

  defp safe_concat(left, right) do
    left  = left  || ""
    right = right || ""
    left <> right
  end
end
