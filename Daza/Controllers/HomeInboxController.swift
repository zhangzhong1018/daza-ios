/**
 * Copyright (C) 2015 JianyingLi <lijy91@foxmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import SVProgressHUD

class HomeInboxController: BaseListController<Notification> {
    
    var menuMarkAllRead: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = trans("home.inbox.title")
        
        self.menuMarkAllRead = UIBarButtonItem(title: "标记已读", style: .Plain, target: self, action: #selector(markAllReadButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = self.menuMarkAllRead
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        self.tableView.registerClass(NotificationItemCell.self, forCellReuseIdentifier: "NotificationItemCell")
        self.tableView.registerNib(UINib(nibName: "NotificationItemCell", bundle: nil), forCellReuseIdentifier: "NotificationItemCell")
        
        self.firstRefreshing()
    }
    
    override func loadData(page: Int) {
        let completionBlock = { (pagination: Pagination!, data: [Notification]!, error: NSError!) -> Void in
            self.loadComplete(pagination, data)
        }
        Api.getNotificationList(page, completion: completionBlock)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NotificationItemCell = tableView.dequeueReusableCellWithIdentifier("NotificationItemCell", forIndexPath: indexPath) as! NotificationItemCell
        
        let data = self.itemsSource[indexPath.row]
        
        cell.data = data
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let data = self.itemsSource[indexPath.row]
        
        let controller = UITableViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func markAllReadButtonPressed(sender: UIBarButtonItem) {
        SVProgressHUD.showWithStatus("处理中...")
        Api.markAsReadNotification { (data, error) in
            if (data) {
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                self.navigationController?.tabBarItem.badgeValue = nil
            } else {
                
            }
            SVProgressHUD.dismiss()
        }
    }
    
}
