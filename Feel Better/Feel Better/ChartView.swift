import UIKit

@IBDesignable class ChartView: UIView {
  
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 10.0
        static let topBorder: CGFloat = 10
        static let bottomBorder: CGFloat = 10
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 12.0
    }
  
    //Weekly sample data
    var graphPoints: [Int] = [4, 2, 15, 4, 5, 8, 3]
  
    override func draw(_ rect: CGRect) {
    
        let width = self.frame.width
        let height = self.frame.height

        let context = UIGraphicsGetCurrentContext()!
    
        //calculate the x point
        let margin = Constants.margin
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin * 2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
    
        // calculate the y point
        let topBorder: CGFloat = Constants.topBorder
        let bottomBorder: CGFloat = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
    
        // draw the line graph
        UIColor.blue.setFill()
        UIColor.blue.setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0), y:columnYPoint(graphPoints[0])))
    
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
        
//            let midPoint = midPointFor(p1: CGPoint(x: columnXPoint(i-1), y: columnYPoint(graphPoints[i-1])), p2: CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i])))
//
//            graphPath.addQuadCurve(to: midPoint, controlPoint: controlPointForPoints(p1: midPoint, p2: CGPoint(x: columnXPoint(i-1), y: columnYPoint(graphPoints[i-1]))))
//            graphPath.addQuadCurve(to: midPoint, controlPoint: CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i])))
//
//            graphPath.addCurve(to: nextPoint, controlPoint1: controlPointForPoints(p1: midPoint, p2: CGPoint(x: columnXPoint(i-1), y: columnYPoint(graphPoints[i-1]))), controlPoint2: CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i])))
            
            graphPath.lineJoinStyle = .round
            graphPath.addLine(to: nextPoint)
        }
    
        //Create the clipping path for the graph gradient
    
        //1 - save the state of the context (commented out for now)
        context.saveGState()
    
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
    
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
    
        //4 - add the clipping path to the context
        clippingPath.addClip()
    
 
        context.restoreGState()
    
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
      
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.lineWidth = 2.0
            circle.stroke()
       
        }
        
        // add weekday labels
        
        for i in 0..<7{
            let label = UILabel(frame: CGRect(x: columnXPoint(i), y: graphHeight+topBorder, width: 10, height: 10))
            label.font = .systemFont(ofSize: CGFloat(10))
            label.textColor = .blue
            label.text = "F"
            self.addSubview(label)
        }
    
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()

        //top line
        linePath.move(to: CGPoint(x:margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y:topBorder))

        //center line
        linePath.move(to: CGPoint(x:margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x:width - margin, y:graphHeight/2 + topBorder))

        //bottom line
        linePath.move(to: CGPoint(x:margin, y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:width - margin, y:height - bottomBorder))
        let color = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        color.setStroke()

        linePath.lineWidth = 0.5
        linePath.stroke()
        
        // add y value labels
        
        let zeroLabel = UILabel(frame: CGRect(x: width-(margin/2), y: (topBorder/2)+graphHeight, width: 15, height: 20))
        zeroLabel.text = "0"
        zeroLabel.font = .systemFont(ofSize: CGFloat(10))
        zeroLabel.textColor = .blue
        zeroLabel.textAlignment = .right
        self.addSubview(zeroLabel)
        
        let middleLabel = UILabel(frame: CGRect(x: width-(margin/2), y: graphHeight/2 + topBorder, width: 15, height: 20))
        middleLabel.text = "\(maxValue / 2)"
        middleLabel.font = .systemFont(ofSize: CGFloat(10))
        middleLabel.textColor = .blue
        middleLabel.textAlignment = .right
        self.addSubview(middleLabel)
        
        let maxLabel = UILabel(frame: CGRect(x: width-(margin/2), y: topBorder, width: 15, height: 20))
        maxLabel.text = "\(maxValue)"
        maxLabel.font = .systemFont(ofSize: CGFloat(10))
        maxLabel.textColor = .blue
        maxLabel.textAlignment = .right
        self.addSubview(maxLabel)
    }
    
    
//    func midPointFor(p1:CGPoint,p2:CGPoint)->CGPoint{
//        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
//    }
//
//    func controlPointForPoints(p1:CGPoint,p2:CGPoint)->CGPoint{
//        var controlPoint = midPointFor(p1: p1, p2: p2)
//        let diffY = abs(p2.y - controlPoint.y)
//
//        if p1.y < p2.y{
//            controlPoint.y += diffY;
//        }else if p1.y > p2.y{
//            controlPoint.y -= diffY;
//        }
//        return controlPoint;
//    }
    
}
