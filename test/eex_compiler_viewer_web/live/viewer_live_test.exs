defmodule EexCompilerViewerWeb.ViewerLiveTest do
  use EexCompilerViewerWeb.ConnCase

  import Phoenix.LiveViewTest
  import EexCompilerViewer.ViewersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_viewer(_) do
    viewer = viewer_fixture()
    %{viewer: viewer}
  end

  describe "Index" do
    setup [:create_viewer]

    test "lists all viewers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.viewer_index_path(conn, :index))

      assert html =~ "Listing Viewers"
    end

    test "saves new viewer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.viewer_index_path(conn, :index))

      assert index_live |> element("a", "New Viewer") |> render_click() =~
               "New Viewer"

      assert_patch(index_live, Routes.viewer_index_path(conn, :new))

      assert index_live
             |> form("#viewer-form", viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#viewer-form", viewer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.viewer_index_path(conn, :index))

      assert html =~ "Viewer created successfully"
    end

    test "updates viewer in listing", %{conn: conn, viewer: viewer} do
      {:ok, index_live, _html} = live(conn, Routes.viewer_index_path(conn, :index))

      assert index_live |> element("#viewer-#{viewer.id} a", "Edit") |> render_click() =~
               "Edit Viewer"

      assert_patch(index_live, Routes.viewer_index_path(conn, :edit, viewer))

      assert index_live
             |> form("#viewer-form", viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#viewer-form", viewer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.viewer_index_path(conn, :index))

      assert html =~ "Viewer updated successfully"
    end

    test "deletes viewer in listing", %{conn: conn, viewer: viewer} do
      {:ok, index_live, _html} = live(conn, Routes.viewer_index_path(conn, :index))

      assert index_live |> element("#viewer-#{viewer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#viewer-#{viewer.id}")
    end
  end

  describe "Show" do
    setup [:create_viewer]

    test "displays viewer", %{conn: conn, viewer: viewer} do
      {:ok, _show_live, html} = live(conn, Routes.viewer_show_path(conn, :show, viewer))

      assert html =~ "Show Viewer"
    end

    test "updates viewer within modal", %{conn: conn, viewer: viewer} do
      {:ok, show_live, _html} = live(conn, Routes.viewer_show_path(conn, :show, viewer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Viewer"

      assert_patch(show_live, Routes.viewer_show_path(conn, :edit, viewer))

      assert show_live
             |> form("#viewer-form", viewer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#viewer-form", viewer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.viewer_show_path(conn, :show, viewer))

      assert html =~ "Viewer updated successfully"
    end
  end
end
