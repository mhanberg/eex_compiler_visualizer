defmodule EexCompilerViewer do
  @moduledoc """
  EexCompilerViewer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def with_bitstring(assigns) do
    arg0 = String.Chars.to_string(EEx.Engine.fetch_assign!(var!(assigns), :user).name)

    arg1 =
      String.Chars.to_string(
        for user <- EEx.Engine.fetch_assign!(var!(assigns), :users) do
          arg1 = String.Chars.to_string(user.name)
          "\n    <li>" <> arg1 <> "</li>\n  "
        end
      )

    "<!-- single line expression -->\n<span>" <>
      arg0 <> "</span>\n\n<!-- block expression -->\n<ul>\n  " <> arg1 <> "\n</ul>"
  end

  def with_concatenation(assigns) do
    arg0 = String.Chars.to_string(EEx.Engine.fetch_assign!(var!(assigns), :user).name)

    arg1 =
      String.Chars.to_string(
        for user <- EEx.Engine.fetch_assign!(var!(assigns), :users) do
          arg1 = String.Chars.to_string(user.name)
          <<"\n    <li>", arg1::binary, "</li>\n  ">>
        end
      )

    <<"<!-- single line expression -->\n<span>", arg0::binary,
      "</span>\n\n<!-- block expression -->\n<ul>\n  ", arg1::binary, "\n</ul>">>
  end

  def with_iolist(assigns) do
    arg0 =
      case Phoenix.HTML.Engine.fetch_assign!(var!(assigns), :user).name do
        {:safe, data} -> data
        bin when is_binary(bin) -> Phoenix.HTML.Engine.html_escape(bin)
        other -> Phoenix.HTML.Safe.to_iodata(other)
      end

    arg1 =
      case (for user <- Phoenix.HTML.Engine.fetch_assign!(var!(assigns), :users) do
              arg1 =
                case user.name do
                  {:safe, data} -> data
                  bin when is_binary(bin) -> Phoenix.HTML.Engine.html_escape(bin)
                  other -> Phoenix.HTML.Safe.to_iodata(other)
                end

              {:safe, ["\n    <li>", arg1, "</li>\n  "]}
            end) do
        {:safe, data} -> data
        bin when is_binary(bin) -> Phoenix.HTML.Engine.html_escape(bin)
        other -> Phoenix.HTML.Safe.to_iodata(other)
      end

    {:safe,
     [
       "<!-- single line expression -->\n<span>",
       arg0,
       "</span>\n\n<!-- block expression -->\n<ul>\n  ",
       arg1,
       "\n</ul>"
     ]}
  end
end
