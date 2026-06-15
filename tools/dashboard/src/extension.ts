import * as vscode from "vscode";
import { FrameworkModel } from "./model";
import { DashboardPanel } from "./dashboardPanel";
import { QueueProvider, ReportsProvider, SlicesProvider, TargetsProvider } from "./treeProviders";

export function activate(context: vscode.ExtensionContext): void {
  let model: FrameworkModel | null = null;
  const resolveModel = (): FrameworkModel | null => {
    const root = FrameworkModel.resolveRoot();
    if (!root) {
      model = null;
    } else if (!model || model.root !== root) {
      model = new FrameworkModel(root);
    }
    return model;
  };

  const targets = new TargetsProvider(resolveModel);
  const slices = new SlicesProvider(resolveModel);
  const queue = new QueueProvider(resolveModel);
  const reports = new ReportsProvider(resolveModel);

  context.subscriptions.push(
    vscode.window.registerTreeDataProvider("sddTargets", targets),
    vscode.window.registerTreeDataProvider("sddSlices", slices),
    vscode.window.registerTreeDataProvider("sddQueue", queue),
    vscode.window.registerTreeDataProvider("sddReports", reports)
  );

  const statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50);
  statusBar.command = "sdd.openDashboard";
  context.subscriptions.push(statusBar);

  const refreshAll = (): void => {
    targets.refresh();
    slices.refresh();
    queue.refresh();
    reports.refresh();
    const m = resolveModel();
    DashboardPanel.refreshIfOpen(m);
    if (m) {
      const escalated = m.stats().escalated;
      statusBar.text = escalated > 0 ? `$(warning) SDD: ${escalated} escalated` : "$(shield) SDD";
      statusBar.tooltip = "Software Development Agent Framework — open dashboard";
      statusBar.backgroundColor =
        escalated > 0 ? new vscode.ThemeColor("statusBarItem.warningBackground") : undefined;
      statusBar.show();
    } else {
      statusBar.hide();
    }
  };

  context.subscriptions.push(
    vscode.commands.registerCommand("sdd.refresh", refreshAll),
    vscode.commands.registerCommand("sdd.openDashboard", () => DashboardPanel.show(resolveModel))
  );

  // Watch framework state dirs; re-arm when the resolved root changes.
  let watcher: vscode.FileSystemWatcher | undefined;
  let debounce: NodeJS.Timeout | undefined;
  const armWatcher = (): void => {
    watcher?.dispose();
    const m = resolveModel();
    if (!m) {
      return;
    }
    watcher = vscode.workspace.createFileSystemWatcher(
      new vscode.RelativePattern(vscode.Uri.file(m.root), "{specs,work-queue,review-reports,targets,wiki}/**")
    );
    const onChange = (): void => {
      if (debounce) {
        clearTimeout(debounce);
      }
      debounce = setTimeout(refreshAll, 400);
    };
    watcher.onDidCreate(onChange);
    watcher.onDidChange(onChange);
    watcher.onDidDelete(onChange);
    context.subscriptions.push(watcher);
  };

  context.subscriptions.push(
    vscode.workspace.onDidChangeWorkspaceFolders(() => {
      armWatcher();
      refreshAll();
    }),
    vscode.workspace.onDidChangeConfiguration((e) => {
      if (e.affectsConfiguration("sddDashboard")) {
        armWatcher();
        refreshAll();
      }
    })
  );

  armWatcher();
  refreshAll();
}

export function deactivate(): void {
  // Disposables handled via context.subscriptions.
}
